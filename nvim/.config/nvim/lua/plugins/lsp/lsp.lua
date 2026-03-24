-- plugins/lsp.lua
return {
  ---------------------------------------------------------------------------
  -- 1. SchemaStore & Linting (The DevOps Core)
  ---------------------------------------------------------------------------
  { "b0o/SchemaStore.nvim", lazy = true },
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")

      lint.linters_by_ft = {
        yaml = { "yamllint", "actionlint" },
        ansible = { "ansible-lint" },
        dockerfile = { "hadolint" },
        json = { "jsonlint" },
      }

      -- Deduplicated augroup to avoid duplicate autocmds on re-source
      local lint_group = vim.api.nvim_create_augroup("DevOpsLint", { clear = true })

      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost" }, {
        group = lint_group,
        callback = function()
          lint.try_lint()

          -- Run kube-linter only if file looks like a Kubernetes manifest
          local lines = vim.api.nvim_buf_get_lines(0, 0, 10, false)
          for _, line in ipairs(lines) do
            if line:match("^apiVersion:") then
              lint.try_lint("kube-linter")
              break
            end
          end
        end,
      })
    end,
  },

  ---------------------------------------------------------------------------
  -- 2. Mason (Binary Management)
  ---------------------------------------------------------------------------
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    opts = {
      ui = { border = "rounded" },
      ensure_installed = {
        "actionlint",
        "ansible-lint",
        "yamllint",
        "prettier",
        "hadolint",
        "kube-linter",
        "shfmt",
      },
    },
  },

  ---------------------------------------------------------------------------
  -- 3. LSP Configuration
  -- LazyVim 2026: uses vim.lsp.config() + automatic_enable via mason-lspconfig
  -- Handlers pattern is deprecated — use opts.servers + opts.setup instead
  ---------------------------------------------------------------------------
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
      -- config = function() end tells LazyVim NOT to call setup() itself
      { "mason-org/mason-lspconfig.nvim", config = function() end },
      "saghen/blink.cmp",
    },
    opts = {
      -- vim.diagnostic.config() options
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
        },
        severity_sort = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "✘",
            [vim.diagnostic.severity.WARN] = "▲",
            [vim.diagnostic.severity.HINT] = "◆",
            [vim.diagnostic.severity.INFO] = "●",
          },
        },
      },

      inlay_hints = { enabled = true },

      -- setup[server] = function(server, opts) return true to skip auto-setup
      setup = {},

      servers = {
        -- JENKINS
        groovy_ls = {},

        -- ANSIBLE
        ansiblels = {},

        -- YAML: SchemaStore + disable on Ansible buffers
        yamlls = {
          on_attach = function(client, bufnr)
            if vim.bo[bufnr].filetype == "yaml.ansible" then
              client.stop()
            end
          end,
          on_new_config = function(new_config)
            new_config.settings.yaml.schemas = vim.tbl_deep_extend(
              "force",
              new_config.settings.yaml.schemas or {},
              require("schemastore").yaml.schemas()
            )
          end,
          settings = {
            redhat = { telemetry = { enabled = false } },
            yaml = {
              keyOrdering = false,
              format = { enable = true },
              validate = true,
              schemaStore = { enable = false, url = "" },
            },
          },
        },

        -- DOCKER / SHELL / LUA
        dockerls = {},
        bashls = {},
        lua_ls = {
          settings = {
            Lua = { diagnostics = { globals = { "vim" } } },
          },
        },

        -- JSON: SchemaStore
        jsonls = {
          on_new_config = function(new_config)
            new_config.settings.json.schemas = new_config.settings.json.schemas or {}
            vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
          end,
          settings = { json = { validate = { enable = true } } },
        },
      },
    },

    config = function(_, opts)
      -- ── Filetype detection ──────────────────────────────────────────────
      vim.filetype.add({
        filename = {
          -- Jenkinsfile variants → groovy LSP
          ["Jenkinsfile"] = "groovy",
          ["alpha"] = "groovy",
          ["beta"] = "groovy",
          ["prod"] = "groovy",

          -- Dockerfile variants → dockerls
          ["Dockerfile.alpha"] = "dockerfile",
          ["Dockerfile.beta"] = "dockerfile",
          ["Dockerfile.prod"] = "dockerfile",
          ["Dockerfile.demo"] = "dockerfile",
        },
        pattern = {
          -- Dynamic Jenkinsfile patterns
          [".*%.jenkinsfile"] = "groovy",
          ["Jenkinsfile%..+"] = "groovy",

          -- Dynamic Dockerfile patterns
          ["Dockerfile%..+"] = "dockerfile",

          -- Ansible detection
          [".*/tasks/.*%.ya?ml"] = "yaml.ansible",
          [".*/playbooks/.*%.ya?ml"] = "yaml.ansible",
          [".*/handlers/.*%.ya?ml"] = "yaml.ansible",
          [".*/roles/.*%.ya?ml"] = "yaml.ansible",
        },
      })

      -- ── Diagnostics ─────────────────────────────────────────────────────
      vim.diagnostic.config(opts.diagnostics)

      -- ── Inlay hints (Neovim 0.10+) ──────────────────────────────────────
      if opts.inlay_hints.enabled then
        vim.api.nvim_create_autocmd("LspAttach", {
          callback = function(args)
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            if client and client.supports_method("textDocument/inlayHint") then
              vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
            end
          end,
        })
      end

      -- ── blink.cmp capabilities ───────────────────────────────────────────
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      -- ── mason-lspconfig: automatic_enable replaces handlers pattern ──────
      local mason_lspconfig = require("mason-lspconfig")
      local server_names = vim.tbl_keys(opts.servers)

      mason_lspconfig.setup({
        ensure_installed = server_names,
        automatic_enable = true,
      })

      -- Configure each server via vim.lsp.config() (Neovim 0.11+ native API)
      for server, server_opts in pairs(opts.servers) do
        server_opts = vim.tbl_deep_extend("force", {
          capabilities = capabilities,
        }, server_opts)

        -- Allow per-server setup override
        local setup_override = opts.setup[server] or opts.setup["*"]
        if not (setup_override and setup_override(server, server_opts)) then
          vim.lsp.config(server, server_opts)
        end
      end
    end,
  },

  ---------------------------------------------------------------------------
  -- 4. Completion (blink.cmp)
  ---------------------------------------------------------------------------
  {
    "saghen/blink.cmp",
    version = "*",
    opts = {
      keymap = { preset = "default" },
      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = "mono",
      },
      completion = {
        documentation = { auto_show = true, window = { border = "rounded" } },
        ghost_text = { enabled = true },
      },
      signature = { enabled = true, window = { border = "rounded" } },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
    },
  },
}
