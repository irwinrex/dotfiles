return {
  -- Enhanced file type detection for shell scripts
  {
    "LazyVim/LazyVim",
    init = function()
      vim.filetype.add({
        pattern = {
          [".*%.env"] = "sh",
          [".*%.env%..*"] = "sh",
          [".*/%.bashrc"] = "bash",
          [".*/%.bash_profile"] = "bash",
          [".*/%.bash_aliases"] = "bash",
          [".*/%.zshrc"] = "zsh",
          [".*/%.zsh_profile"] = "zsh",
        },
      })
    end,
  },

  -- Enhanced LSP configuration
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        bashls = {
          filetypes = { "sh", "bash", "zsh" },
          settings = {
            bashIde = {
              -- Enhanced glob pattern for better file detection
              globPattern = "**/*@(.sh|.inc|.bash|.command|.zsh)",
              -- Background analysis
              backgroundAnalysisMaxFiles = 500,
              -- Enhanced completion
              enableSourceErrorDiagnostics = true,
              -- Shell check integration
              shellcheckPath = "shellcheck",
              shellcheckArguments = {
                "--format=json",
                "--shell=bash",
                "--enable=all",
                "--exclude=SC1091", -- Exclude sourcing warnings
              },
              -- Explainer integration
              includeAllWorkspaceSymbols = true,
            },
          },
        },
      },
    },
  },

  -- Enhanced linting configuration
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        sh = { "shellcheck" },
        bash = { "shellcheck" },
        zsh = { "shellcheck" },
      },
      linters = {
        shellcheck = {
          args = {
            "--format=json",
            "--shell=bash",
            "--enable=all",
            "--exclude=SC1091,SC2034,SC2155", -- Common exclusions
            "--severity=style",
            "-",
          },
          condition = function(ctx)
            return vim.fn.executable("shellcheck") == 1
          end,
        },
      },
    },
  },

  -- Shell formatting
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        sh = { "shfmt" },
        bash = { "shfmt" },
        zsh = { "shfmt" },
      },
      formatters = {
        shfmt = {
          args = {
            "-i",
            "2", -- 2 spaces indentation
            "-ci", -- switch cases indent
            "-sr", -- redirect operators will be followed by a space
            "-kp", -- keep column alignment paddings
            "-fn", -- function opening braces are placed on a separate line
          },
        },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
    },
  },
  -- Shell-specific keymaps and commands
  {
    "LazyVim/LazyVim",
    keys = {
      { "<leader>cR", "<cmd>ShellRun<cr>", desc = "Shell Run", ft = { "sh", "bash", "zsh" } },
      { "<leader>cx", "<cmd>ShellExecute<cr>", desc = "Shell Execute", ft = { "sh", "bash", "zsh" } },
      { "<leader>cc", "<cmd>ShellCheck<cr>", desc = "Shell Check", ft = { "sh", "bash", "zsh" } },
      { "<leader>cf", "<cmd>ShellFormat<cr>", desc = "Shell Format", ft = { "sh", "bash", "zsh" } },
      { "<leader>ch", "<cmd>ShellHarden<cr>", desc = "Shell Harden", ft = { "sh", "bash", "zsh" } },
      { "<leader>cm", "<cmd>ShellMakeExecutable<cr>", desc = "Make Executable", ft = { "sh", "bash", "zsh" } },
    },
    init = function()
      -- Enhanced shell commands
      vim.api.nvim_create_user_command("ShellRun", function()
        local file = vim.fn.expand("%")
        vim.cmd("!bash " .. file)
      end, { desc = "Run shell script" })

      vim.api.nvim_create_user_command("ShellExecute", function()
        local file = vim.fn.expand("%")
        vim.cmd("!" .. file)
      end, { desc = "Execute shell script directly" })

      vim.api.nvim_create_user_command("ShellCheck", function()
        local file = vim.fn.expand("%")
        vim.cmd("!shellcheck --format=gcc --enable=all " .. file)
      end, { desc = "Run shellcheck analysis" })

      vim.api.nvim_create_user_command("ShellFormat", function()
        local file = vim.fn.expand("%")
        vim.cmd("!shfmt -i 2 -ci -sr -kp -fn -w " .. file)
      end, { desc = "Format shell script" })

      vim.api.nvim_create_user_command("ShellHarden", function()
        local file = vim.fn.expand("%")
        vim.cmd("!shellharden --suggest " .. file)
      end, { desc = "Shell hardening suggestions" })

      vim.api.nvim_create_user_command("ShellMakeExecutable", function()
        local file = vim.fn.expand("%")
        vim.cmd("!chmod +x " .. file)
        print("Made " .. file .. " executable")
      end, { desc = "Make shell script executable" })

      -- Auto-format on save for shell files
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = { "*.sh", "*.bash", "*.zsh" },
        callback = function()
          vim.lsp.buf.format({ timeout_ms = 500 })
        end,
      })

      -- Enhanced shell file settings
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "sh", "bash", "zsh" },
        callback = function()
          vim.opt_local.expandtab = true
          vim.opt_local.tabstop = 2
          vim.opt_local.shiftwidth = 2
          vim.opt_local.softtabstop = 2
          -- Enable spell checking for comments
          vim.opt_local.spell = true
          vim.opt_local.spelllang = "en_us"
        end,
      })

      -- Auto-add shebang for new shell files
      vim.api.nvim_create_autocmd("BufNewFile", {
        pattern = { "*.sh", "*.bash" },
        callback = function()
          vim.api.nvim_put({ "#!/bin/bash", "", "" }, "l", false, true)
          vim.api.nvim_win_set_cursor(0, { 3, 0 })
        end,
      })

      vim.api.nvim_create_autocmd("BufNewFile", {
        pattern = { "*.zsh" },
        callback = function()
          vim.api.nvim_put({ "#!/bin/zsh", "", "" }, "l", false, true)
          vim.api.nvim_win_set_cursor(0, { 3, 0 })
        end,
      })
    end,
  },
}
