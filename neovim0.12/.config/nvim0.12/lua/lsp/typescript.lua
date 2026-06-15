vim.lsp.config("ts_ls", {
  init_options = {
    plugins = {
      {
        name = "@styled/typescript-plugin",
        location = "",
        languages = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
      },
    },
  },
})
vim.lsp.enable("ts_ls")
