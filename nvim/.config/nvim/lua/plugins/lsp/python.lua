-- Python LSP and tooling
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ruff = {
          on_attach = function(client)
            -- Disable semantic tokens to prioritize Tree-sitter highlights
            client.server_capabilities.semanticTokensProvider = nil
            client.server_capabilities.hoverProvider = false
          end,
        },
        basedpyright = {
          -- Fix: Improved root detection for monorepos and virtualenvs
          root_dir = function(fname)
            local util = require("lspconfig.util")
            return util.root_pattern(".git", "pyproject.toml", "requirements.txt", "setup.py", ".venv", "venv")(fname)
              or util.path.dirname(fname)
          end,
          settings = {
            basedpyright = {
              analysis = {
                typeCheckingMode = "standard", -- Less noisy than "basic" while still being helpful
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "openFilesOnly", -- Only show errors for files you're actually looking at
                -- Disable specific noisy basedpyright warnings
                diagnosticSeverityOverrides = {
                  reportGeneralTypeIssues = "warning", -- Don't let type issues stop you if you're experimenting
                  reportUnusedImport = "none", -- Let Ruff handle this
                  reportUnusedVariable = "none", -- Let Ruff handle this
                  reportOptionalMemberAccess = "none", -- Often noisy in dynamic Python
                },
              },
            },
          },
        },
        pyright = { enabled = false },
      },
    },
  },
}
