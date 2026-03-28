-- Go LSP and tooling
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gopls = {
          settings = {
            gopls = {
              gofumpt = true,
              codelenses = {
                generate = true,
                run_govulncheck = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
              },
              hints = {
                assignVariableTypes = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
              analyses = {
                unusedparams = true,
                shadow = true,
                nilness = true,
                unreachable = true,
              },
              staticcheck = true,
              vulncheck = "Imports",
              memfs = {},
              directoryFilters = {},
            },
          },
        },
      },
      inlay_hints = { enabled = true },
    },
  },
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
      { "<leader>got", "<cmd>GoTest<cr>", desc = "Run tests" },
      { "<leader>gof", "<cmd>GoFmt<cr>", desc = "Format code" },
    },
  },
}
