-- Groovy/Jenkinsfile LSP and filetype
return {
  {
    "neovim/nvim-lspconfig",
    ft = { "groovy", "Jenkinsfile" },
    config = function()
      local lspconfig = require("lspconfig")
      lspconfig.groovy_ls.setup({
        on_attach = function(client, _)
          client.server_capabilities.semanticTokensProvider = nil
        end,
      })
    end,
  },
  {
    "nvim-lua/plenary.nvim",
    lazy = true,
  },
}