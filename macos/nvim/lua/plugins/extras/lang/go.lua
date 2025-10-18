return {
  -- Go LSP setup
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.servers.gopls = {
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
      }
    end,

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
    },

    init = function()
      -- === Custom Go Commands ===
      local cmd = vim.api.nvim_create_user_command

      cmd("GoRun", function()
        vim.fn.system({ "go", "run", vim.fn.expand("%") })
        vim.notify("Go Run executed", vim.log.levels.INFO)
      end, {})

      cmd("GoTest", function()
        vim.fn.system({ "gotestsum", "--format=testname", "./..." })
        vim.notify("Running all tests...", vim.log.levels.INFO)
      end, {})

      cmd("GoTestFunc", function()
        local func_name = vim.fn.expand("<cword>")
        vim.fn.system({ "gotestsum", "--format=testname", "--", "-run=" .. func_name })
        vim.notify("Testing function: " .. func_name, vim.log.levels.INFO)
      end, {})

      cmd("GoTestAll", function()
        vim.fn.system({ "gotestsum", "--format=standard-verbose", "./..." })
      end, {})

      cmd("GoCoverage", function()
        vim.fn.system({ "go", "test", "-coverprofile=coverage.out", "./..." })
        vim.fn.system({ "go", "tool", "cover", "-html=coverage.out" })
      end, {})

      cmd("GoGenerate", function()
        vim.fn.system({ "go", "generate", "./..." })
      end, {})

      cmd("GoMod", function()
        vim.fn.system({ "go", "mod", "tidy" })
        vim.fn.system({ "go", "mod", "verify" })
        vim.notify("Go modules synced", vim.log.levels.INFO)
      end, {})

      cmd("GoVulnCheck", function()
        vim.fn.system({ "govulncheck", "./..." })
        vim.notify("Vulnerability check complete", vim.log.levels.INFO)
      end, {})

      cmd("GoWorkspace", function()
        vim.fn.system({ "go", "work", "sync" })
        vim.notify("Workspace synced", vim.log.levels.INFO)
      end, {})

      -- Go file settings
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

  -- GolangCI-Lint setup
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      local lint = require("lint")

      opts.linters_by_ft = opts.linters_by_ft or {}
      opts.linters_by_ft.go = { "golangci_lint" }

      lint.linters.golangci_lint = {
        cmd = "golangci-lint",
        stdin = false,
        args = {
          "run",
          "--out-format",
          "json",
          "--issues-exit-code=1",
          "--print-issued-lines=false",
          "--print-linter-name=true",
          "--max-issues-per-linter=0",
          "--max-same-issues=0",
          "--path-prefix",
          vim.fn.getcwd(),
        },
        ignore_exitcode = true, -- prevents breaking on exit code 3
        parser = function(output, bufnr)
          local ok, decoded = pcall(vim.json.decode, output)
          if not ok or not decoded or not decoded.Issues then
            return {}
          end

          local diagnostics = {}
          for _, issue in ipairs(decoded.Issues) do
            table.insert(diagnostics, {
              lnum = issue.Pos.Line - 1,
              col = issue.Pos.Column - 1,
              message = string.format("[%s] %s", issue.FromLinter or "golangci", issue.Text),
              severity = vim.diagnostic.severity.WARN,
              source = "golangci-lint",
            })
          end
          return diagnostics
        end,
      }

      -- Optional: auto-lint on save
      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        pattern = "*.go",
        callback = function()
          require("lint").try_lint()
        end,
      })
    end,
  },
}
