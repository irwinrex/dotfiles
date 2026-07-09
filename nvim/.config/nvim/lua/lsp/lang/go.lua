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
      semanticTokens = true,
      directoryFilters = { "-vendor" },
      hints = {
        assignVariableTypes = true,
        parameterNames = true,
        rangeVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        functionTypeParameters = true,
      },
    },
  },
})
vim.lsp.enable("gopls")
