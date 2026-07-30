vim.lsp.config("gopls", {
  settings = {
    gopls = {
      analyses = {
        -- Already enabled
        unusedparams = true,
        nilness = true,
        unusedwrite = true,
        -- High-value additions
        shadow = true,
        lostcancel = true,
        nilfunc = true,
        structtag = true,
        unreachable = true,
        unusedvariable = true,
        slog = true,
        appends = true,
        assign = true,
        atomic = true,
        defers = true,
        infertypeargs = true,
        useany = true,
        testinggoroutine = true,
        -- Code-action analyzers (fill struct/return suggestions)
        fillreturns = true,
        fillstruct = true,
      },
      staticcheck = true,
      gofumpt = true,
      usePlaceholders = false,
      semanticTokens = true,
      directoryFilters = { "-vendor", "-**/.git", "-**/node_modules" },
    },
  },
})
vim.lsp.enable("gopls")

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    local clients = vim.lsp.get_clients({ name = "gopls", bufnr = 0 })
    if #clients > 0 then
      vim.lsp.buf.code_action({
        context = { only = { "source.organizeImports" } },
        apply = true,
      })
    end
  end,
})
