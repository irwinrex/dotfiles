-- Go LSP and tooling
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gopls = {
          -- Fix: Better monorepo/submodule root detection
          root_dir = function(fname)
            local util = require("lspconfig.util")
            return util.root_pattern("go.work", "go.mod", ".git")(fname)
              or util.path.dirname(fname)
          end,
          settings = {
            gopls = {
              gofumpt = true,
              usePlaceholders = true,
              completeUnimported = true,
              staticcheck = true,
              directoryFilters = { "-.git", "-node_modules", "-.terraform" },
              semanticTokens = false, -- Redundant with Tree-sitter
              codelenses = {
                generate = true,
                run_govulncheck = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
              },
              hints = {
                assignVariableTypes = false, -- Often redundant and noisy
                parameterNames = true,
                rangeVariableTypes = false,
              },
              analyses = {
                unusedparams = false, -- Too noisy during rapid development
                shadow = true,
                nilness = true,
                unreachable = true,
                unusedwrite = true,
              },
              vulncheck = "Imports",
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
