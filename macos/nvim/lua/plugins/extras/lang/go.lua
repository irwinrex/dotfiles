-- go.lua
-- Comprehensive Go development setup for Neovim
-- Includes: gopls LSP, custom commands (run/test/generate), golangci-lint, filetype opts
-- Compatible with Neovim 0.10+ (2025 standards)
-- Requires: gotestsum, govulncheck, golangci-lint (via Mason)

return {
  --=====================================================================
  -- 1. gopls (LSP) + Keybindings + Filetype Settings
  --=====================================================================
  -- Repo: https://github.com/neovim/nvim-lspconfig
  -- Configures gopls with advanced settings for completions, diagnostics, hints
  -- Adds user commands for common Go tasks (run, test, coverage, etc.)
  -- Sets Go-specific buffer options (tabs = 4, no expandtab)
  {
    "neovim/nvim-lspconfig",
    ft = "go", -- Lazy-load on Go files
    opts = function(_, opts)
      -- Merge with existing servers config
      opts.servers = opts.servers or {}
      opts.servers.gopls = {
        settings = {
          gopls = {
            -- Core completions & formatting
            usePlaceholders = true,
            completeUnimported = true,
            staticcheck = true,
            gofumpt = true,

            -- Matching & fuzzy
            matcher = "Fuzzy",
            fuzzyMatching = true,
            caseSensitiveCompletion = false,

            -- Advanced analyses (diagnostics)
            analyses = {
              unusedparams = true,
              shadow = true,
              unusedvariable = true,
              unusedwrite = true,
              nilness = true,
              useany = true,
              unreachable = true,
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

            -- Inlay hints (semantic)
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              compositeLiteralTypes = true,
              constantValues = true,
              functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },

            -- Codelens (actions in editor)
            codelenses = {
              generate = true,
              test = true,
              tidy = true,
              upgrade_dependency = true,
              vendor = true,
            },

            -- Build & environment
            buildFlags = { "-tags=integration" },
            env = { GOFLAGS = "-tags=integration" },
            vulncheck = "Imports", -- Scan imports for vulns

            -- Performance tweaks
            memoryMode = "DegradeClosed",
            diagnosticsDelay = "250ms",
            diagnosticsTrigger = "Edit",

            -- Template support
            templateExtensions = { "tmpl", "gotmpl", "html" },

            -- Experimental features
            experimentalPostfixCompletions = true,
            experimentalWorkspaceModule = true,
            deepCompletion = true,
            semanticTokens = true,
          },
        },
      }
      return opts
    end,

    -- Keybindings: <leader>c* for Go commands (lazy-loaded)
    keys = {
      { "<leader>cR", "<cmd>GoRun<cr>", desc = "Run Go file", ft = "go" },
      { "<leader>ct", "<cmd>GoTest<cr>", desc = "Test package", ft = "go" },
      { "<leader>cT", "<cmd>GoTestFunc<cr>", desc = "Test function", ft = "go" },
      { "<leader>ca", "<cmd>GoTestAll<cr>", desc = "Test all", ft = "go" },
      { "<leader>cc", "<cmd>GoCoverage<cr>", desc = "Coverage", ft = "go" },
      { "<leader>cg", "<cmd>GoGenerate<cr>", desc = "Generate", ft = "go" },
      { "<leader>cm", "<cmd>GoModTidy<cr>", desc = "Mod tidy", ft = "go" },
      { "<leader>cv", "<cmd>GoVulnCheck<cr>", desc = "Vuln check", ft = "go" },
    },

    -- Initialization: User commands + filetype autocmds
    init = function()
      local cmd = vim.api.nvim_create_user_command

      -- Modern floating terminal: vim.loop.spawn + nvim_open_term
      -- Handles output streaming, auto-scroll, clean exit (Neovim 0.10+ compatible)
      local function float_term(command, title)
        -- Create scratch buffer
        local buf = vim.api.nvim_create_buf(false, true)
        vim.bo[buf].bufhidden = "wipe" -- Auto-delete on close

        -- Open floating window
        local win = vim.api.nvim_open_win(buf, true, {
          relative = "editor",
          width = vim.o.columns - 10,
          height = 20,
          row = vim.o.lines - 25,
          col = 5,
          style = "minimal",
          border = "rounded",
          title = title,
          title_pos = "center",
        })

        -- Open terminal channel
        local chan = vim.api.nvim_open_term(buf, {})

        -- Pipes for stdout/stderr
        local stdout = vim.loop.new_pipe(false)
        local stderr = vim.loop.new_pipe(false)
        local handle

        -- Spawn process (with explicit nil fields to satisfy type checker)
        handle = vim.loop.spawn(command[1], {
          args = { unpack(command, 2) }, -- Pass args as table
          stdio = { nil, stdout, stderr }, -- Inherit stdin, pipe out/err
          env = nil, -- Inherit env
          cwd = nil, -- Inherit cwd
          uid = nil, -- No uid change
          gid = nil, -- No gid change
          verbatim = nil, -- No verbatim
          detached = nil, -- Not detached
          hide = nil, -- Don't hide
        }, function()
          -- Cleanup on exit (with nil checks)
          if stdout then
            stdout:read_stop()
            stdout:close()
          end
          if stderr then
            stderr:read_stop()
            stderr:close()
          end
          if handle then
            handle:close()
          end
          -- Close window safely
          vim.schedule(function()
            vim.api.nvim_win_close(win, true)
          end)
        end)

        -- Stream data to terminal (stdout + stderr)
        local function on_data(err, data)
          if err or not data then
            return
          end
          vim.schedule(function()
            if chan then
              vim.api.nvim_chan_send(chan, data) -- Send to term
            end
            -- Auto-scroll to bottom if focused
            local line_count = vim.api.nvim_buf_line_count(buf)
            if vim.api.nvim_get_current_win() == win then
              vim.api.nvim_win_set_cursor(win, { line_count, 0 })
            end
          end)
        end

        if stdout then
          stdout:read_start(on_data)
        end
        if stderr then
          stderr:read_start(on_data)
        end

        -- Enter insert mode (non-deprecated)
        vim.schedule(function()
          vim.api.nvim_feedkeys("i", "n", false)
        end)
      end

      --=== User Commands: Custom Go Tasks =================================
      -- All use floating terminal for output (non-blocking)
      cmd("GoRun", function()
        float_term({ "go", "run", vim.fn.expand("%:p") }, " go run ")
      end, { desc = "Run current file" })

      cmd("GoTest", function()
        float_term({ "gotestsum", "--format=testname", "./..." }, " gotestsum ")
      end, { desc = "Run package tests" })

      cmd("GoTestFunc", function()
        local func = vim.fn.expand("<cword>")
        float_term({ "gotestsum", "--", "-run=" .. func .. "$" }, " Test: " .. func .. " ")
      end, { desc = "Test current function" })

      cmd("GoTestAll", function()
        float_term({ "gotestsum", "--format=standard-verbose", "./..." }, " gotestsum all ")
      end, { desc = "Run all tests (verbose)" })

      cmd("GoCoverage", function()
        local cov = "coverage.out"
        vim.fn.system({ "go", "test", "-coverprofile=" .. cov, "./..." })
        if vim.v.shell_error == 0 then
          vim.fn.system({ "go", "tool", "cover", "-html=" .. cov })
          vim.notify("Coverage opened", vim.log.levels.INFO)
        else
          vim.notify("Coverage failed", vim.log.levels.ERROR)
        end
      end, { desc = "Generate & open coverage" })

      cmd("GoGenerate", function()
        vim.fn.system({ "go", "generate", "./..." })
        vim.notify("go generate done", vim.log.levels.INFO)
      end, { desc = "Run go generate" })

      cmd("GoModTidy", function()
        vim.fn.system({ "go", "mod", "tidy" })
        vim.fn.system({ "go", "mod", "verify" })
        vim.notify("go mod tidy + verify", vim.log.levels.INFO)
      end, { desc = "Tidy & verify modules" })

      cmd("GoVulnCheck", function()
        if vim.fn.executable("govulncheck") ~= 1 then
          vim.notify("govulncheck not found", vim.log.levels.WARN)
          return
        end
        float_term({ "govulncheck", "./..." }, " govulncheck ")
      end, { desc = "Run govulncheck" })

      --=== Filetype Autocmds: Go Buffer Options ===========================
      -- Set tabs=4, no expandtab (Go standard)
      local go_group = vim.api.nvim_create_augroup("GoFileSettings", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        group = go_group,
        pattern = "go",
        callback = function()
          vim.bo.expandtab = false
          vim.bo.tabstop = 4
          vim.bo.shiftwidth = 4
          vim.bo.softtabstop = 4
        end,
      })
    end,
  },

  --=====================================================================
  -- 2. golangci-lint: Linting via nvim-lint
  --=====================================================================
  -- Repo: https://github.com/mfussenegger/nvim-lint
  -- Parses golangci-lint JSON output into Neovim diagnostics
  -- Auto-runs on save (only if go.mod exists)
  {
    "mfussenegger/nvim-lint",
    ft = "go", -- Lazy-load
    opts = function(_, opts)
      local lint = require("lint")

      -- Add to existing linters_by_ft
      opts.linters_by_ft = opts.linters_by_ft or {}
      opts.linters_by_ft.go = { "golangci_lint" }

      -- Custom golangci-lint config
      lint.linters.golangci_lint = {
        name = "golangci_lint",
        cmd = "golangci-lint",
        stdin = false,
        stream = "stdout",
        args = {
          "run",
          "--out-format=json",
          "--issues-exit-code=0", -- Don't fail on issues
          "--print-issued-lines=false",
          "--print-linter-name=true",
          "--max-same-issues=0",
          "$DIRNAME", -- Current dir
        },
        ignore_exitcode = true,
        -- Parse JSON into diagnostics (with severity mapping)
        parser = function(output)
          if output == "" then
            return {}
          end
          local ok, decoded = pcall(vim.json.decode, output)
          if not ok or not decoded.Issues then
            return {}
          end
          local diagnostics = {}
          local sev_map = {
            E = vim.diagnostic.severity.ERROR,
            W = vim.diagnostic.severity.WARN,
            I = vim.diagnostic.severity.INFO,
            H = vim.diagnostic.severity.HINT,
          }
          for _, issue in ipairs(decoded.Issues) do
            local sev = sev_map[issue.Severity:sub(1, 1):upper()] or vim.diagnostic.severity.WARN
            table.insert(diagnostics, {
              lnum = issue.Pos.Line - 1,
              col = issue.Pos.Column - 1,
              end_lnum = issue.Pos.Line - 1,
              end_col = issue.Pos.Column,
              message = string.format("[%s] %s", issue.FromLinter or "golangci", issue.Text),
              severity = sev,
              source = "golangci-lint",
              code = issue.FromLinter,
            })
          end
          return diagnostics
        end,
      }

      -- Auto-lint on save (only in Go modules)
      local lint_group = vim.api.nvim_create_augroup("GoLintOnSave", { clear = true })
      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        group = lint_group,
        pattern = "*.go",
        callback = function()
          -- Check for go.mod in project root
          local root = vim.fs.dirname(vim.fs.find("go.mod", {
            upward = true,
            path = vim.api.nvim_buf_get_name(0),
          })[1])
          if root then
            lint.try_lint()
          end
        end,
      })

      return opts
    end,
  },
}
