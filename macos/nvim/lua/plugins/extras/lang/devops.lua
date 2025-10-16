return {
  {
    "LazyVim/LazyVim",
    init = function()
      vim.filetype.add({
        filename = {
          ["Jenkinsfile"] = "groovy",
        },
        pattern = {
          ["Jenkinsfile.*"] = "groovy",
          [".*%.jenkinsfile"] = "groovy",
        },
      })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "b0o/schemastore.nvim",
    },
    opts = function(_, opts)
      opts.servers = vim.tbl_deep_extend("force", opts.servers or {}, {
        yamlls = {
          settings = {
            yaml = {
              validate = true,
              hover = true,
              completion = true,
              schemas = require("schemastore").yaml.schemas(),
              format = {
                enable = true,
              },
            },
          },
        },
        dockerls = {
          settings = {
            docker = {
              languageserver = {
                formatter = {
                  ignoreMultilineInstructions = true,
                },
              },
            },
          },
        },
        groovyls = {
          filetypes = { "groovy" },
        },
      })
      return opts
    end,
  },

  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      opts.linters_by_ft = vim.tbl_deep_extend("force", opts.linters_by_ft or {}, {
        yaml = { "yamllint" },
        dockerfile = { "hadolint" },
      })
      return opts
    end,
  },
}
