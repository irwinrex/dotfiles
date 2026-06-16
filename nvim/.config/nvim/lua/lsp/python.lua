vim.lsp.config("ruff", {
  init_options = {
    settings = { organizeImports = true },
  },
})
vim.lsp.enable("ruff")

vim.lsp.config("basedpyright", {
  on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = false
  end,
  settings = {
    basedpyright = {
      analysis = {
        typeCheckingMode = "basic",
        autoImportCompletions = true,
        diagnosticSeverityOverrides = {
          reportUndefinedVariable = "information",
          reportUnknownMemberType = "none",
          reportUnknownArgumentType = "none",
          reportMissingTypeStubs = "none",
        },
      },
    },
  },
})
vim.lsp.enable("basedpyright")
