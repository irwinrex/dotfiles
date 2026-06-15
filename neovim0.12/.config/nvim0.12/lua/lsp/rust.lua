vim.lsp.config("rust_analyzer", {
  settings = {
    ["rust-analyzer"] = {
      cargo = { allFeatures = true },
      check = { command = "clippy" },
      procMacro = { enable = true },
      diagnostics = {
        disabled = { "unresolved-proc-macro" },
      },
    },
  },
})
vim.lsp.enable("rust_analyzer")
