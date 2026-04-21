-- Go LSP and tooling
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gopls = {
          root_dir = function(fname)
            local util = require("lspconfig.util")
            return util.root_pattern("go.work", "go.mod", ".git")(fname) or vim.fs.dirname(fname)
          end,
          settings = {
            gopls = {
              gofumpt = true,
              usePlaceholders = true,
              completeUnimported = true,
              staticcheck = true,
              directoryFilters = { "-.git", "-node_modules", "-.terraform" },
              semanticTokens = false,
              codelenses = {
                generate = true,
                run_govulncheck = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
              },
              hints = {
                assignVariableTypes = false, -- Prime hates type noise
                parameterNames = false,
                rangeVariableTypes = false,
                compositeLiteralFields = true, -- ADDED: helpful in structs
                functionTypeParameters = true, -- ADDED: generics clarity
              },
              analyses = {
                unusedparams = true, -- Prime would want this ON
                shadow = true,
                nilness = true,
                unreachable = true,
                unusedwrite = true,
                useany = true, -- ADDED: catch interface{} usage
                fieldalignment = true, -- ADDED: struct memory layout warnings
              },
              vulncheck = "Imports",
            },
          },
        },
      },
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
