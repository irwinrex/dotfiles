vim.lsp.config("ruff", {
  init_options = {
    settings = { organizeImports = true },
  },
})
vim.lsp.enable("ruff")

vim.lsp.config("basedpyright", {
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
