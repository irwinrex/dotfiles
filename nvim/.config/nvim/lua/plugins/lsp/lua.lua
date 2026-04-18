-- Lua LSP configuration
return {
  {
    "neovim/nvim-lspconfig",
    ft = "lua",
    config = function()
      local lspconfig = require("lspconfig")
      lspconfig.lua_ls.setup({
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
          },
        },
        on_attach = function(client, _)
          client.server_capabilities.semanticTokensProvider = nil
        end,
      })
    end,
  },
}