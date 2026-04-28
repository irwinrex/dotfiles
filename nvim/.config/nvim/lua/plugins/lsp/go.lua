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
  }
