return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        basedpyright = {
          settings = {
            basedpyright = {
              typeCheckingMode = "standard",
              useLibraryCodeForTypes = true,
              autoImportCompletions = true,
              analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "openFilesOnly",
                stubPath = "typings",
                typeshedPaths = {},
                diagnosticSeverityOverrides = {
                  reportUnusedImport = "information",
                  reportUnusedVariable = "information",
                  reportDuplicateImport = "warning",
                  reportOptionalSubscript = "warning",
                  reportOptionalMemberAccess = "warning",
                  reportOptionalCall = "warning",
                  reportOptionalIterable = "warning",
                  reportOptionalContextManager = "warning",
                  reportOptionalOperand = "warning",
                  reportUnboundVariable = "error",
                  reportGeneralTypeIssues = "error",
                },
              },
              venvPath = ".",
              venv = "venv",
              completion = {
                importFormat = "absolute",
                snippetSupport = true,
              },
            },
          },
        },
      },
    },
  },

  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        python = { "ruff", "mypy" },
      },
      linters = {
        ruff = {
          cmd = "ruff",
          args = {
            "check",
            "--output-format=json",
            "--stdin-filename",
            function()
              return vim.api.nvim_buf_get_name(0)
            end,
            "-",
          },
        },
        mypy = {
          args = {
            "--show-column-numbers",
            "--show-error-end",
            "--hide-error-codes",
            "--hide-error-context",
            "--no-color-output",
            "--no-error-summary",
            "--no-pretty",
            function()
              return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":p")
            end,
          },
        },
      },
    },
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        python = { "ruff_format", "ruff_organize_imports" },
      },
      formatters = {
        ruff_format = {
          command = "ruff",
          args = {
            "format",
            "--stdin-filename",
            "$FILENAME",
            "-",
          },
        },
        ruff_organize_imports = {
          command = "ruff",
          args = {
            "check",
            "--select",
            "I",
            "--fix",
            "--stdin-filename",
            "$FILENAME",
            "-",
          },
        },
      },
      format_on_save = {
        timeout_ms = 1000,
        lsp_fallback = true,
      },
    },
  },

  {
    "mfussenegger/nvim-dap",
    optional = true,
    dependencies = {
      "mfussenegger/nvim-dap-python",
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
    },
    config = function()
      local dap_python = require("dap-python")
      dap_python.setup("python") -- Uses system python, adjust as needed
      dap_python.test_runner = "pytest"
    end,
  },
}
