-- Python LSP and tooling
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ruff = {
          on_attach = function(client)
            client.server_capabilities.hoverProvider = false
          end,
        },
        basedpyright = {
          settings = {
            basedpyright = {
              analysis = {
                typeCheckingMode = "basic",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "openFilesOnly",
              },
            },
          },
        },
        pyright = { enabled = false },
      },
    },
  },
}
