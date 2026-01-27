-- ~/.config/nvim/lua/plugins/language/python.lua

return {
  -- 1. LSP CONFIGURATION
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- 2026 Best Practice: Use 'ruff' server, NOT 'ruff_lsp'
        ruff = {
          -- Performance: Disable ruff's hover in favor of basedpyright
          on_attach = function(client)
            client.server_capabilities.hoverProvider = false
          end,
          settings = {
            -- Any specific ruff settings go here
            args = {},
          },
        },

        -- Basedpyright for Type Checking & IntelliSense
        basedpyright = {
          settings = {
            basedpyright = {
              analysis = {
                typeCheckingMode = "basic", -- "standard" for stricter, "basic" for speed
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "openFilesOnly", -- HUGE performance boost for large repos
              },
            },
          },
        },

        -- Disable standard pyright to prevent conflicts
        pyright = { enabled = false },
      },
    },
  },

  -- 2. TOOLING (Mason ensures everything is installed)
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "basedpyright", "ruff" })
    end,
  },

  -- 3. FORMATTING (Conform)
  -- Ruff is the fastest formatter in the ecosystem.
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        python = { "ruff_format", "ruff_organize_imports" },
      },
    },
  },

  -- 4. PERFORMANCE TWEAK: LSP CAPABILITIES
  -- Ensure blink.cmp is used for Python completion
  {
    "saghen/blink.cmp",
    opts = {
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
    },
  },
}
