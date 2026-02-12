-- ~/.config/nvim/lua/plugins/language/python.lua

return {
  ---------------------------------------------------------------------------
  -- 1. LSP CONFIGURATION
  ---------------------------------------------------------------------------
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ruff = {
          setup = {
            on_attach = function(client)
              client.server_capabilities.hoverProvider = false
            end,
          },
        },

        basedpyright = {
          settings = {
            basedpyright = {
              analysis = {
                typeCheckingMode = "basic",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "openFilesOnly",
              },
            },
          },
        },

        pyright = { enabled = false },
      },
    },
  },

  ---------------------------------------------------------------------------
  -- 2. TOOLING (Mason Integration)
  ---------------------------------------------------------------------------
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "basedpyright", "ruff" })
    end,
  },

  ---------------------------------------------------------------------------
  -- 3. FORMATTING (Conform)
  ---------------------------------------------------------------------------
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        -- Ruff handles both layout and import sorting in a single pass
        python = { "ruff_organize_imports", "ruff_format" },
      },
    },
  },

  ---------------------------------------------------------------------------
  -- 4. COMPLETION (Blink.cmp)
  ---------------------------------------------------------------------------
  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      opts.sources.default = { "lsp", "path", "snippets", "buffer" }
    end,
  },
}
