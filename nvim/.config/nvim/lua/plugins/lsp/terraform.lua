-- lua/plugins/terraform.lua
return {
  -- ─── LSP: terraformls ────────────────────────────────────────────────
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        terraformls = {
          root_dir = require("lspconfig.util").root_pattern("terragrunt.hcl", ".terraform", ".git", "main.tf", "*.tf"),

          -- Key fix: watch all .tf file changes across workspace automatically
          capabilities = {
            workspace = {
              didChangeWatchedFiles = {
                dynamicRegistration = true,
              },
            },
          },

          on_attach = function(client, _)
            -- Let conform.nvim handle formatting, not LSP
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
          end,

          settings = {
            ["terraform-ls"] = {
              -- Don't require terraform init to get basic LSP features
              ignoreSingleFileWarning = true,
              -- Disable noisy validation in monorepos / uninitialized workspaces
              validation = {
                enableEnhancedValidation = false,
              },
              -- Experimental but useful for large monorepos
              indexing = {
                ignorePaths = {
                  ".terraform",
                  "**/.terraform",
                },
                ignoreDirectoryNames = {
                  ".terraform",
                  "node_modules",
                  ".git",
                },
              },
            },
            terraform = {
              experimentalFeatures = {
                prefillRequiredFields = true,
              },
            },
          },
        },
      },
    },
  },
}
