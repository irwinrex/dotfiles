-- Terraform/HCL LSP and tooling
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        terraformls = {
          root_dir = require("lspconfig.util").root_pattern("terragrunt.hcl", ".terraform", ".git", "main.tf"),
          on_attach = function(client, bufnr)
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
              -- Only validate when .terraform dir exists (i.e. after init)
              validation = {
                enableEnhancedValidation = false,
              },
              -- Ignore dirs that are clearly not initialized roots
              ignoreSingleFileWarning = true,
            },
          },
        },
      },
      setup = {
        terraformls = function(_, opts)
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
          -- Disable the built-in terraform validate runner inside tflint.
          -- "terraform validate" requires `terraform init` and is too noisy
          -- in monorepos with many uninitialized workspaces.
          args = {
            "--disable-rule=terraform_required_providers",
            "--no-color",
            "--format=json",
          },
        },
      },
    },
  },
}
