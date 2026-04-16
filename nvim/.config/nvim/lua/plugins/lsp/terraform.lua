-- lua/plugins/terraform.lua
return {
  -- ─── LSP: terraformls ────────────────────────────────────────────────
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        terraformls = {
          root_dir = require("lspconfig.util").root_pattern("terragrunt.hcl", ".terraform", ".git", "main.tf", "*.tf"),
          capabilities = {
            workspace = {
              didChangeWatchedFiles = {
                dynamicRegistration = true, -- auto re-index on cross-file changes
              },
            },
          },
          on_attach = function(client, _)
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
          end,
          settings = {
            ["terraform-ls"] = {
              ignoreSingleFileWarning = true,
              validation = {
                enableEnhancedValidation = false,
              },
              indexing = {
                ignorePaths = { ".terraform", "**/.terraform" },
                ignoreDirectoryNames = { ".terraform", "node_modules", ".git" },
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
