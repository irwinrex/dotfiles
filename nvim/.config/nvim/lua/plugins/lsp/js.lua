-- JavaScript LSP configuration
return {
  {
    "neovim/nvim-lspconfig",
    ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    config = function()
      local lspconfig = require("lspconfig")
      lspconfig.ts_ls.setup({
        on_attach = function(client, _)
          client.server_capabilities.semanticTokensProvider = nil
        end,
      })
      lspconfig.quick_lint_js.setup({
        on_attach = function(client, _)
          client.server_capabilities.semanticTokensProvider = nil
        end,
      })
    end,
  },
}