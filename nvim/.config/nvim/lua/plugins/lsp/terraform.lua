-- lua/plugins/terraform.lua

return {
  -- ─── LSP: terraformls ────────────────────────────────────────────────
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        terraformls = {
          -- Fix 2: monorepo root detection — walks UP until it finds any .tf file dir
          root_dir = function(fname)
            local util = require("lspconfig.util")
            -- Try specific markers first
            local root = util.root_pattern("terragrunt.hcl", ".terraform", ".terraform.lock.hcl")(fname)
            if root then
              return root
            end
            -- Fallback: treat the directory containing the .tf file as root
            -- This handles flat module dirs like shared/
            return util.root_pattern("*.tf")(fname) or vim.fn.fnamemodify(fname, ":h")
          end,

          capabilities = {
            workspace = {
              didChangeWatchedFiles = {
                dynamicRegistration = true,
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
