-- ~/.config/nvim/lua/plugins/language/go.lua

return {
  ---------------------------------------------------------------------------
  -- 1. LSP & Inlay Hints
  ---------------------------------------------------------------------------
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gopls = {
          settings = {
            gopls = {
              gofumpt = true,
              codelenses = { generate = true, run_govulncheck = true, test = true, tidy = true },
              hints = {
                assignVariableTypes = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
              analyses = { unusedparams = true, shadow = true },
              staticcheck = true,
              vulncheck = "Imports",
            },
          },
        },
      },
      inlay_hints = { enabled = true },
    },
  },

  ---------------------------------------------------------------------------
  -- 2. Tooling & Formatting (Consolidated)
  ---------------------------------------------------------------------------
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "gopls", "gofumpt", "goimports-reviser", "delve" })
    end,
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        go = { "goimports-reviser", "gofumpt" },
      },
    },
  },

  ---------------------------------------------------------------------------
  -- 3. Lightweight Helpers (Struct Tags & Impls)
  ---------------------------------------------------------------------------
  {
    "olexsmir/gopher.nvim",
    ft = "go",
    build = function()
      vim.cmd.MasonInstall("gomodifytags impl")
    end,
    opts = {},
    keys = {
      { "<leader>gsj", "<cmd>GoTagAdd json<cr>", desc = "Add JSON tags" },
      { "<leader>gsy", "<cmd>GoTagAdd yaml<cr>", desc = "Add YAML tags" },
      { "<leader>gie", "<cmd>GoIfErr<cr>", desc = "Generate if err" },
    },
  },

  ---------------------------------------------------------------------------
  -- 4. Completion
  ---------------------------------------------------------------------------
  {
    "saghen/blink.cmp",
    opts = {
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
    },
  },
}
