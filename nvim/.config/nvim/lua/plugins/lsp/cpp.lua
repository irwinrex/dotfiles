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
  }
