-- C/C++ LSP and tooling
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = {
          settings = {
            clangd = {
              arguments = {
                "--background-index",
                "--clang-tidy",
                "--header-insertion=iwyu",
              },
            },
          },
        },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        c = { "clang_format" },
        cpp = { "clang_format" },
      },
    },
  },
}
