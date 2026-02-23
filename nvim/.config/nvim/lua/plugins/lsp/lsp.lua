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

      -- Context-aware linting for DevOps 2026
      lint.linters_by_ft = {
        yaml = { "yamllint", "actionlint" },
        ansible = { "ansible-lint" },
        dockerfile = { "hadolint" },
        json = { "jsonlint" },
      }

      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost" }, {
        callback = function()
          lint.try_lint()

          -- Kubernetes Logic: Run kube-linter if 'apiVersion' is found
          local lines = vim.api.nvim_buf_get_lines(0, 0, 10, false)
          for _, line in ipairs(lines) do
            if line:match("apiVersion:") then
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
    "williamboman/mason.nvim",
    cmd = "Mason",
    opts = {
      ui = { border = "rounded" },
      ensure_installed = {
        "actionlint", -- GitHub Actions Logic
        "ansible-lint", -- Ansible Logic
        "yamllint", -- YAML Syntax logic
        "prettier", -- Industry Standard Formatter
        "hadolint", -- Dockerfile logic
        "kube-linter", -- Kubernetes Security
        "shfmt", -- Shell script formatting
      },
    },
  },

  ---------------------------------------------------------------------------
  -- 3. LSP Configuration
  ---------------------------------------------------------------------------
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "saghen/blink.cmp",
    },
    opts = {
      diagnostics = {
        underline = true,
        update_in_insert = false,
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

      servers = {
        -- JENKINS
        groovy_ls = {},

        -- ANSIBLE
        ansiblels = {},

        -- YAML: With dynamic SchemaStore integration
        yamlls = {
          -- 2026 Trick: If it's an Ansible file, stop yamlls to prevent duplicate errors
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

        -- MISC CLOUD/SYSTEM TOOLS
        dockerls = {},
        bashls = {},
        lua_ls = {
          settings = { Lua = { diagnostics = { globals = { "vim" } } } },
        },
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
      local lspconfig = require("lspconfig")

      -- Filetype overrides for Jenkins and Ansible detection
      vim.filetype.add({
        pattern = {
          ["Jenkinsfile"] = "groovy",
          [".*%.jenkinsfile"] = "groovy",
          [".*/tasks/.*%.yml"] = "yaml.ansible",
          [".*/tasks/.*%.yaml"] = "yaml.ansible",
          [".*/playbooks/.*%.yml"] = "yaml.ansible",
          [".*/playbooks/.*%.yaml"] = "yaml.ansible",
        },
      })

      require("mason-lspconfig").setup({
        ensure_installed = vim.tbl_keys(opts.servers),
        handlers = {
          function(server_name)
            local server_opts = opts.servers[server_name] or {}
            server_opts.capabilities = require("blink.cmp").get_lsp_capabilities(server_opts.capabilities)
            lspconfig[server_name].setup(server_opts)
          end,
        },
      })
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
