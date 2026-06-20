vim.lsp.config("gopls", {
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
        nilness = true,
        unreachable = true,
        unusedwrite = true,
        useany = true,
      },
      staticcheck = true,
      gofumpt = true,
      hints = {
        assignVariableTypes = false,
        parameterNames = false,
        rangeVariableTypes = false,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        functionTypeParameters = true,
      },
    },
  },
})
vim.lsp.enable("gopls")
