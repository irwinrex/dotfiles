-- Terraform/HCL LSP and tooling
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        terraformls = {
          root_dir = require("lspconfig.util").root_pattern("terragrunt.hcl", ".terraform", ".git", "main.tf"),
          capabilities = {
            workspace = {
              didChangeWatchedFiles = {
                dynamicRegistration = true,
              },
            },
          },
          on_attach = function(client)
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
          end,
          settings = {
            terraform = {
              experimentalFeatures = {
                prefillRequiredFields = true,
              },
            },
            ["terraform-ls"] = {
              validation = {
                enableEnhancedValidation = false,
              },
              ignoreSingleFileWarning = true,
            },
          },
        },
      },
      setup = {
        terraformls = function(_)
          return true
        end,
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        terraform = { "tflint" },
        tf = { "tflint" },
      },
      linters = {
        tflint = {
          args = {
            "--disable-rule=terraform_required_providers",
            "--format=json",
          },
        },
      },
    },
  },
}
