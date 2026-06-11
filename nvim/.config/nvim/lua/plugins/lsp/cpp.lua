-- C/C++ LSP and tooling
return {
  {
    "neovim/nvim-lspconfig",
    ft = { "c", "cpp", "objc", "objcpp" },
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
