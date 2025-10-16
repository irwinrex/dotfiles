return {
  -- Configure the Terraform LSP server
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        terraformls = {
          settings = {
            terraform = {
              languageServer = {
                experimentalFeatures = {
                  validateOnSave = true,
                },
                diagnostics = {
                  enable = true,
                  ignoreRule = {
                    "TF_UNKNOWN_PROVIDER",
                    "TF_VAR_NOT_FOUND",
                    "TF_MISSING_MODULE",
                  },
                },
                indexWorkspace = true,
              },
              format = {
                enable = true,
              },
            },
          },
        },
      },
    },
  },

  -- Configure tflint for linting
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        terraform = { "tflint" },
      },
    },
  },
}
