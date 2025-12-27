-- ~/.config/nvim/lua/plugins/language/python.lua
return {
  ---------------------------------------------------------------------------
  -- Python LSPs: basedpyright + ruff-lsp
  ---------------------------------------------------------------------------
  {
    "neovim/nvim-lspconfig",
    ft = { "python" },
    opts = function(_, opts)
      opts.servers = opts.servers or {}

      -----------------------------------------------------------------------
      -- Disable the default Pyright (LazyVim enables it automatically)
      -----------------------------------------------------------------------
      opts.servers.pyright = { enabled = false }

      -----------------------------------------------------------------------
      -- Ruff LSP (Lint + Format + Code Actions)
      -----------------------------------------------------------------------
      opts.servers.ruff_lsp = {
        init_options = {
          settings = {
            args = {},
          },
        },
      }

      -----------------------------------------------------------------------
      -- BasedPyright (Type Checking + IntelliSense)
      -----------------------------------------------------------------------
      opts.servers.basedpyright = {
        settings = {
          basedpyright = {
            typeCheckingMode = "basic",
            analysis = {
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
            },
          },
        },
      }

      return opts
    end,
  },

  ---------------------------------------------------------------------------
  -- Python Formatting (Ruff)
  ---------------------------------------------------------------------------
  {
    "stevearc/conform.nvim",
    ft = { "python" },
    opts = {
      formatters_by_ft = {
        python = { "ruff_format" },
      },
    },
  },
}
