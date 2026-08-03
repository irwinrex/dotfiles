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
      usePlaceholders = true,
      completeUnimported = true,
      semanticTokens = false,
      directoryFilters = { "-**/.git", "-**/node_modules", "-**/vendor" },
      hints = {
        assignVariableTypes = false,
        compositeLiteralFields = true,
        constantValues = true,
        parameterNames = true,
        rangeVariableTypes = false,
        functionTypeParameters = false,
      },
    },
  },
})
vim.lsp.enable("gopls")

-- Enable inlay hints for gopls (Neovim 0.10+)
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.name == "gopls" then
      vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
    end
  end,
})
