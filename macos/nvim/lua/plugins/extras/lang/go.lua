return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gopls = {
          settings = {
            gopls = {
              staticcheck = true,
              usePlaceholders = true,
              completeUnimported = true,
              matcher = "Fuzzy",
              gofumpt = true,
              experimentalPostfixCompletions = true,
              experimentalWorkspaceModule = true,
              vulncheck = "Imports",
              codelenses = {
                generate = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
                vendor = true,
              },
              semanticTokens = true,
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
              analyses = {
                unusedparams = true,
                unreachable = true,
                shadow = true,
                useany = true,
                unusedvariable = true,
                unusedwrite = true,
                nilness = true,
                printf = true,
                shift = true,
                simplifycompositelit = true,
                simplifyrange = true,
                simplifyslice = true,
                sortslice = true,
                testinggoroutine = true,
                timeformat = true,
                undeclaredname = true,
                unusedresult = true,
              },
              buildFlags = { "-tags", "integration" },
              env = {
                GOFLAGS = "-tags=integration",
                CGO_ENABLED = "0",
              },
              diagnosticsDelay = "250ms",
              diagnosticsTrigger = "Edit",
              analysisProgressReporting = true,
              templateExtensions = { "html", "tmpl", "gotmpl" },
              memoryMode = "DegradeClosed",
              deepCompletion = true,
              fuzzyMatching = true,
              caseSensitiveCompletion = false,
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
        go = { "golangci_lint" },
      },
      linters = {
        golangci_lint = {
          cmd = "golangci-lint",
          args = {
            "run",
            "--out-format=json",
            "--print-issued-lines=false",
            "--print-linter-name=true",
            "--uniq-by-line=false",
            "--max-issues-per-linter=0",
            "--max-same-issues=0",
            function()
              return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":h")
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
        go = { "goimports", "gofumpt" },
      },
      formatters = {
        goimports = {
          args = { "-local", "github.com/yourorg" },
        },
        gofumpt = {
          args = { "-extra" },
        },
      },
      format_on_save = {
        timeout_ms = 1000,
        lsp_fallback = true,
      },
    },
  },

  {
    "LazyVim/LazyVim",
    keys = {
      { "<leader>cR", "<cmd>GoRun<cr>", desc = "Go Run", ft = "go" },
      { "<leader>ct", "<cmd>GoTest<cr>", desc = "Go Test", ft = "go" },
      { "<leader>cT", "<cmd>GoTestFunc<cr>", desc = "Go Test Function", ft = "go" },
      { "<leader>ca", "<cmd>GoTestAll<cr>", desc = "Go Test All", ft = "go" },
      { "<leader>cc", "<cmd>GoCoverage<cr>", desc = "Go Coverage", ft = "go" },
      { "<leader>cg", "<cmd>GoGenerate<cr>", desc = "Go Generate", ft = "go" },
      { "<leader>cm", "<cmd>GoMod<cr>", desc = "Go Mod Tidy", ft = "go" },
      { "<leader>cv", "<cmd>GoVulnCheck<cr>", desc = "Go Vulnerability Check", ft = "go" },
      { "<leader>cw", "<cmd>GoWorkspace<cr>", desc = "Go Workspace", ft = "go" },
      { "<leader>cI", "<cmd>GoImplInterface<cr>", desc = "Implement Interface", ft = "go" },
      { "<leader>cF", "<cmd>GoFillStruct<cr>", desc = "Fill Struct", ft = "go" },
    },
    init = function()
      vim.api.nvim_create_user_command("GoRun", function()
        vim.cmd("!go run " .. vim.fn.expand("%"))
      end, {})

      vim.api.nvim_create_user_command("GoTest", function()
        vim.cmd("!gotestsum --format=testname ./...")
      end, {})

      vim.api.nvim_create_user_command("GoTestFunc", function()
        local func_name = vim.fn.expand("<cword>")
        vim.cmd("!gotestsum --format=testname -- -run=" .. func_name)
      end, {})

      vim.api.nvim_create_user_command("GoTestAll", function()
        vim.cmd("!gotestsum --format=standard-verbose ./...")
      end, {})

      vim.api.nvim_create_user_command("GoCoverage", function()
        vim.cmd("!go test -coverprofile=coverage.out ./... && go tool cover -html=coverage.out")
      end, {})

      vim.api.nvim_create_user_command("GoGenerate", function()
        vim.cmd("!go generate ./...")
      end, {})

      vim.api.nvim_create_user_command("GoMod", function()
        vim.cmd("!go mod tidy && go mod verify")
      end, {})

      vim.api.nvim_create_user_command("GoVulnCheck", function()
        vim.cmd("!govulncheck ./...")
      end, {})

      vim.api.nvim_create_user_command("GoWorkspace", function()
        vim.cmd("!go work sync")
      end, {})

      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.go",
        callback = function()
          vim.lsp.buf.format({ timeout_ms = 1000 })
        end,
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "go",
        callback = function()
          vim.opt_local.expandtab = false
          vim.opt_local.tabstop = 4
          vim.opt_local.shiftwidth = 4
          vim.opt_local.softtabstop = 4
        end,
      })
    end,
  },
}
