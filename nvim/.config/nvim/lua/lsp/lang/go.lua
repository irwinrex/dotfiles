vim.lsp.config("gopls", {
  settings = {
    gopls = {
      analyses = {
        shadow = true,
        unusedparams = true,
        nilness = true,
        unusedwrite = true,
        useany = true,
      },
      vulncheck = "Imports",
      staticcheck = true,
      gofumpt = true,
      completeUnimported = true,
      usePlaceholders = false,
      semanticTokens = false,
      directoryFilters = { "-**/.git", "-**/node_modules", "-**/vendor" },
    },
  },
})
vim.lsp.enable("gopls")
