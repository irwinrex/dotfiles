-- ~/.config/nvim/lua/plugins/language/go.lua

return {
  -- 1. LSP CONFIGURATION (The Core)
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gopls = {
          settings = {
            gopls = {
              -- Performance: Use gofumpt for stricter formatting
              gofumpt = true,
              -- 2026 Best Practice: Enable all semantic features
              codelenses = {
                gc_details = false,
                generate = true,
                regenerate_cgo = true,
                run_govulncheck = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
                vendor = true,
              },
              hints = {
                assignVariableTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
              analyses = {
                unusedparams = true,
                shadow = true,
                unusedwrite = true,
                useany = true,
              },
              staticcheck = true,
              completeUnimported = true,
              usePlaceholders = true,
              directoryFilters = { "-.git", "-.vscode", "-.idea", "-node_modules" },
            },
          },
        },
      },
      -- Enable Inlay Hints (Built-in Neovim 0.10+)
      setup = {
        gopls = function(_, opts)
          vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(args)
              local client = vim.lsp.get_client_by_id(args.data.client_id)
              if client and client.name == "gopls" then
                -- Enable inlay hints by default for Go
                vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
              end
            end,
          })
        end,
      },
    },
  },

  -- 2. TOOLING (Mason ensures everything is installed)
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "gopls",
        "gofumpt",
        "goimports-reviser",
        "delve", -- Debugger
      })
    end,
  },

  -- 3. FORMATTING (Fast & Deterministic)
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        go = { "goimports-reviser", "gofumpt" },
      },
    },
  },

  -- 4. COMPLETION (Blink - Fast Rust-based completion)
  {
    "saghen/blink.cmp",
    opts = {
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
    },
  },

  -- 5. OPTIONAL: If you still need "go.nvim" tools (tags, struct helpers)
  -- Use a much lighter alternative or just the keymaps
  -- Recommendation: Drop ray-x/go.nvim for pure performance.
}
