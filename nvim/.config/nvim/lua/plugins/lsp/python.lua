-- Python LSP and tooling
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ruff = {
          on_attach = function(client)
            client.server_capabilities.semanticTokensProvider = nil
            client.server_capabilities.hoverProvider = false
          end,
        },
        basedpyright = {
          root_dir = function(fname)
            local util = require("lspconfig.util")
            return util.root_pattern(".git", "pyproject.toml", "requirements.txt", "setup.py", ".venv", "venv")(fname)
              or util.path.dirname(fname)
          end,
          settings = {
            basedpyright = {
              analysis = {
                typeCheckingMode = "standard",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "openFilesOnly",
                diagnosticSeverityOverrides = {
                  reportGeneralTypeIssues = "warning",
                  reportUnusedImport = "none",
                  reportUnusedVariable = "none",
                  reportOptionalMemberAccess = "none",
                },
              },
            },
          },
        },
      },
    },
  },
}