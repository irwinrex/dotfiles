-- ~/.config/nvim/lua/plugins/go.lua

return {
  -- Go specific plugin
  {
    "ray-x/go.nvim",
    ft = { "go", "gomod", "gowork", "gosum" },
    dependencies = {
      "ray-x/guihua.lua",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("go").setup({
        gofmt = "gofumpt", -- format style
        fillstruct = "gopls",
        goimports = "goimports",
        lsp_cfg = false, -- disable internal, handled by LazyVim LSP
        max_line_len = 120,
      })

      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.go",
        callback = function()
          require("go.format").goimport()
        end,
      })
    end,
  },

  -- gopls LSP setup (LazyVim LSP extension)
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gopls = {
          settings = {
            gopls = {
              gofumpt = true,
              staticcheck = true,
              usePlaceholders = true,
              hints = {
                assignVariableTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
            },
          },
        },
      },
    },
  },

  -- Formatter integration with conform.nvim
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        go = { "goimports", "gofumpt" },
      },
    },
  },

  -- Treesitter Go language support
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "go", "gomod", "gosum", "gowork" },
    },
  },

  -- Debugging for Go (DAP)
  {
    "mfussenegger/nvim-dap",
    dependencies = { "leoluz/nvim-dap-go" },
    config = function(_, _)
      require("dap-go").setup()
    end,
  },
}
