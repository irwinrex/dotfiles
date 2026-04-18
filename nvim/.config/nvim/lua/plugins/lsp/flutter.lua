-- plugins/lsp/flutter.lua
return {
  ---------------------------------------------------------------------------
  -- 1. FLUTTER-TOOLS
  ---------------------------------------------------------------------------
  {
    "akinsho/flutter-tools.nvim",
    ft = "dart",
    dependencies = { "nvim-lua/plenary.nvim", "stevearc/dressing.nvim", "saghen/blink.cmp" },
    opts = function()
      return {
        lsp = {
          capabilities = require("blink.cmp").get_lsp_capabilities(),
          settings = {
            showTodos = true,
            completeFunctionCalls = true,
            renameFilesWithClasses = "always",
            updateImportsOnRename = true,
          },
        },
        debugger = {
          enabled = true,
          run_via_dap = true,
          register_configurations = function(_)
            local dap = require("dap")
            dap.configurations.dart = {
              {
                type = "dart",
                request = "launch",
                name = "Launch Flutter",
                program = "lib/main.dart",
                cwd = "${workspaceFolder}",
              },
            }
          end,
        },
      }
    end,
  },

  ---------------------------------------------------------------------------
  -- 2. GLOBAL LSP & UI (Simplified)
  ---------------------------------------------------------------------------
  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = {
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "✘",
            [vim.diagnostic.severity.WARN] = "▲",
            [vim.diagnostic.severity.HINT] = "◆",
            [vim.diagnostic.severity.INFO] = "●",
          },
        },
      },
      servers = {
        dartls = { enabled = false },
      },
    },
  },
}
