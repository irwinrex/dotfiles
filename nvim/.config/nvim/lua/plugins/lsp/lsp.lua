-- ~/plugins/lsp.lua
--
-- LazyVim LSP override — DevOps stack
-- Targets: Neovim 0.11+ · LazyVim latest · mason-org/* (2025-2026)
return {

  ---------------------------------------------------------------------------
  -- 0. Filetype detection — must run at startup, before any LSP event fires
  ---------------------------------------------------------------------------
  {
    -- Attach to a plugin that loads at VeryLazy so this runs early but after
    "nvim-lua/plenary.nvim",
    lazy = true,
    init = function()
      vim.filetype.add({
        -- ── Exact filenames (basename == full match only for root-level files)
        filename = {
          ["Jenkinsfile"] = "groovy",
        },

        -- ── Pattern-based (full-path aware, always use leading .*)
        pattern = {
          -- Dockerfile.<suffix>  →  dockerfile
          -- Handles:  Dockerfile.alpha  Dockerfile.prod  dockerfile.dev  etc.
          [".*[Dd]ockerfile%..+"] = "dockerfile",

          -- Jenkinsfile.<suffix>  →  groovy
          -- Handles:  Jenkinsfile.alpha  Jenkinsfile.beta  Jenkinsfile.prod
          [".*Jenkinsfile%..+"] = "groovy",

          -- <n>.jenkinsfile  →  groovy
          -- Handles:  service.jenkinsfile  app.jenkinsfile
          [".*%.jenkinsfile"] = "groovy",

          -- Bare environment files: alpha / beta / prod / staging / dev / uat
          [".*/(alpha|beta|prod|staging|demo|dev|uat)$"] = {
            priority = 10,
            function(_, bufnr)
              -- Guard: bufnr may not be loaded yet
              if not vim.api.nvim_buf_is_loaded(bufnr) then
                return nil
              end
              local lines = vim.api.nvim_buf_get_lines(bufnr, 0, 20, false)
              for _, line in ipairs(lines) do
                local trimmed = line:match("^%s*(.-)%s*$")
                if trimmed ~= "" then
                  if trimmed:match("^pipeline%s*{") or trimmed:match("^node%s*[({]") then
                    return "groovy"
                  end
                  -- First non-blank line didn't match → not a Jenkinsfile
                  return nil
                end
              end
            end,
          },

          -- Ansible role/task YAML → yaml.ansible
          [".*/tasks/.*%.ya?ml"] = "yaml.ansible",
          [".*/playbooks/.*%.ya?ml"] = "yaml.ansible",
          [".*/handlers/.*%.ya?ml"] = "yaml.ansible",
          [".*/roles/.*%.ya?ml"] = "yaml.ansible",
        },
      })
    end,
  },

  ---------------------------------------------------------------------------
  -- 1. SchemaStore — lazy helper, no setup needed
  ---------------------------------------------------------------------------
  { "b0o/SchemaStore.nvim", lazy = true },

  ---------------------------------------------------------------------------
  -- 2. nvim-lint — linting layer (separate from LSP)
  ---------------------------------------------------------------------------
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      linters_by_ft = {
        yaml = { "yamllint", "actionlint" },
        ["yaml.ansible"] = { "ansible-lint" },
        dockerfile = { "hadolint" },
        json = { "jsonlint" },
      },
    },
    config = function(_, opts)
      local lint = require("lint")

      lint.linters_by_ft = vim.tbl_deep_extend("force", lint.linters_by_ft or {}, opts.linters_by_ft)

      local aug = vim.api.nvim_create_augroup("DevOpsLint", { clear = true })

      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
        group = aug,
        callback = function(ev)
          -- try_lint() is a no-op when no linter matches the current ft
          lint.try_lint()

          -- kube-linter only for Kubernetes manifests
          local lines = vim.api.nvim_buf_get_lines(ev.buf, 0, 15, false)
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
  -- 3. Mason — extend ensure_installed with linter/formatter binaries only.
  ---------------------------------------------------------------------------
  {
    "mason-org/mason.nvim",
    opts = {
      ui = { border = "rounded" },
      ensure_installed = {
        "actionlint", -- GitHub Actions linter
        "ansible-lint", -- Ansible linter
        "yamllint", -- YAML linter
        "hadolint", -- Dockerfile linter
        "kube-linter", -- Kubernetes manifest linter
        "prettier", -- Multi-language formatter
        "shfmt", -- Shell formatter
        "jsonlint", -- JSON linter
      },
    },
  },

  ---------------------------------------------------------------------------
  -- 4. nvim-lspconfig — extend LazyVim's spec via opts only.
  --
  --    LazyVim's configure() loop (lsp/init.lua) will:
  --      • Call vim.lsp.config(server, sopts) for every key in opts.servers
  --      • Pass servers to mason-lspconfig.setup({ ensure_installed })
  --      • Respect setup[server] overrides that return true to skip auto-setup
  --      • Keep its own LspAttach autocmds for keymaps / inlay hints / codelens
  --
  --    DO NOT call mason-lspconfig.setup() or vim.lsp.config() here yourself.
  ---------------------------------------------------------------------------
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {

        -- ── Groovy / Jenkins ─────────────────────────────────────────────
        groovy_ls = {},

        -- ── Ansible ──────────────────────────────────────────────────────
        ansiblels = {},

        -- ── YAML (SchemaStore; self-stops on Ansible buffers) ─────────────
        yamlls = {
          -- Stop yamlls when ansiblels already owns the buffer
          on_attach = function(client, bufnr)
            if vim.bo[bufnr].filetype == "yaml.ansible" then
              client.stop()
            end
          end,
          -- Inject SchemaStore schemas before the server starts
          on_new_config = function(new_config)
            new_config.settings = new_config.settings or {}
            new_config.settings.yaml = new_config.settings.yaml or {}
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
              -- Must be false when using the SchemaStore plugin
              schemaStore = { enable = false, url = "" },
            },
          },
        },

        -- ── Docker ───────────────────────────────────────────────────────
        dockerls = {},

        -- ── Shell ─────────────────────────────────────────────────────────
        bashls = {},

        -- ── Lua (Neovim config) ───────────────────────────────────────────
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = { globals = { "vim" } },
              workspace = { checkThirdParty = false },
              telemetry = { enable = false },
            },
          },
        },

        -- ── JSON (SchemaStore) ────────────────────────────────────────────
        jsonls = {
          on_new_config = function(new_config)
            new_config.settings = new_config.settings or {}
            new_config.settings.json = new_config.settings.json or {}
            new_config.settings.json.schemas = new_config.settings.json.schemas or {}
            vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
          end,
          settings = {
            json = { validate = { enable = true } },
          },
        },
      },

      -- Return true from a setup function to skip LazyVim's auto-configure
      -- for that server and take full manual control.
      setup = {},
    },
  },

  ---------------------------------------------------------------------------
  -- 5. blink.cmp — extend LazyVim's spec only where we need custom behaviour.
  --    Keymap preset, appearance, and sources are already set by LazyVim.
  ---------------------------------------------------------------------------
  {
    "saghen/blink.cmp",
    opts = {
      completion = {
        documentation = { auto_show = true, window = { border = "rounded" } },
        ghost_text = { enabled = true },
      },
      signature = { enabled = true, window = { border = "rounded" } },
    },
  },
}
