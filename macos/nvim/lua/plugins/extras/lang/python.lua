return {
  -- LSP Configuration for basedpyright: Python language server
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        basedpyright = {
          settings = {
            basedpyright = {
              typeCheckingMode = "standard", -- Set type checking strictness
              useLibraryCodeForTypes = true, -- Use type info from libraries
              autoImportCompletions = true, -- Enables import completions
              analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "openFilesOnly", -- Show diagnostics for open files only
                stubPath = "typings", -- Path for stub files
                typeshedPaths = {},
                diagnosticSeverityOverrides = { -- Override severity for specific diagnostics
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
              venvPath = ".", -- Virtual environment path (set relative or absolute)
              venv = "venv", -- Virtual environment folder name within project
              completion = {
                importFormat = "absolute", -- Insert full import paths in completions
                snippetSupport = true, -- Enable snippet support in completions
              },
            },
          },
        },
      },
    },
  },

  -- Linting configuration using nvim-lint with ruff and mypy for Python
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        python = { "ruff", "mypy" }, -- Run both ruff and mypy on Python files
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

  -- Formatting and organizing imports with conform.nvim using ruff
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        python = { "ruff_format", "ruff_organize_imports" }, -- Use ruff both for formatting and import organization
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
        timeout_ms = 1000, -- Timeout for formatting operations
        lsp_fallback = true, -- Fall back on LSP formatting if external formatter missing
      },
    },
  },

  -- Optional debugging configuration for Python using nvim-dap and dap-python
  {
    "mfussenegger/nvim-dap",
    optional = true,
    dependencies = {
      "mfussenegger/nvim-dap-python", -- Python integration for DAP
      "rcarriga/nvim-dap-ui", -- UI for debugging
      "theHamsta/nvim-dap-virtual-text", -- Inline debugging info
    },
    config = function()
      local dap_python = require("dap-python")
      dap_python.setup("python") -- Automatically uses system python or venv python if configured
      dap_python.test_runner = "pytest" -- Use pytest as default test runner
    end,
  },
}
