-- lua/plugins/terraform.lua
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        terraformls = {
          root_dir = function(fname)
            local util = require("lspconfig.util")
            return util.root_pattern(".terraform", "terragrunt.hcl", ".terraform.lock.hcl", ".git")(fname)
              or util.root_pattern("main.tf", "variables.tf")(fname)
              or vim.fs.dirname(fname)
          end,
          capabilities = {
            workspace = {
              didChangeWatchedFiles = {
                dynamicRegistration = true,
              },
            },
          },
          on_attach = function(client, _)
            client.server_capabilities.semanticTokensProvider = nil
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
          end,
          settings = {
            ["terraform-ls"] = {
              ignoreSingleFileWarning = true,
              validation = { enableEnhancedValidation = false },
              indexing = {
                maxDirectories = 500,
                ignorePaths = { ".terraform", "**/.terraform", ".git", "**/node_modules" },
                ignoreDirectoryNames = { ".terraform", "node_modules", ".git" },
              },
            },
            terraform = {
              experimentalFeatures = {
                prefillRequiredFields = true,
                validateOnSave = false,
              },
            },
          },
        },
      },
    },
  },
}
