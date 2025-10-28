-- mason.lua
-- Core Mason configuration: manages LSPs, formatters, linters, debuggers
-- All tools are installed via Mason → no manual PATH setup needed
-- Uses official `mason-org` org (current maintainer of Mason)
-- Compatible with LazyVim defaults: conform.nvim (formatting) + nvim-lint (linting)
-- No none-ls.nvim needed (remove if enabled via extras.lsp.none-ls)

return {
  --=====================================================================
  -- 1. Mason Core: The foundation
  --=====================================================================
  -- Repo: https://github.com/mason-org/mason.nvim
  -- Installs and manages external tools (LSPs, DAP, linters, formatters)
  {
    "mason-org/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUpdate" }, -- Lazy-load on command
    build = ":MasonUpdate", -- Update registry on first install
    opts = {
      ui = {
        -- Clean, minimal UI
        icons = {
          package_installed = "Installed",
          package_pending = "Pending",
          package_uninstalled = "Not Installed",
        },
        border = "rounded",
        width = 0.8,
        height = 0.8,
      },
      log_level = vim.log.levels.WARN, -- Reduce noise
      max_concurrent_installers = 4, -- Speed up installs
    },
    config = function(_, opts)
      require("mason").setup(opts)
    end,
  },

  --=====================================================================
  -- 2. mason-tool-installer: Auto-install all dev tools
  --=====================================================================
  -- Repo: https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim
  -- Ensures every tool below is installed and kept up-to-date
  -- Tools used by conform.nvim (format) + nvim-lint (lint) + DAP
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    event = "VeryLazy", -- Load after startup
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      -- List of **exact** Mason package names (case-sensitive!)
      ensure_installed = {
        -- Shell Scripting
        "shfmt", -- Formatter: gofmt for shell (conform.nvim)
        "shellcheck", -- Linter: SCXXXX diagnostics (nvim-lint)
        "bash-language-server", -- LSP: bashls

        -- YAML & Kubernetes
        "yamllint", -- Linter: .yaml, .yml (nvim-lint)
        "yaml-language-server", -- LSP: yamlls (K8s, Helm, etc.)

        -- JSON
        "json-language-server", -- LSP: jsonls
        "prettier", -- Formatter: JSON, JS, etc. (conform.nvim)

        -- Docker
        "hadolint", -- Linter: Dockerfile (nvim-lint)
        "dockerfile-language-server", -- LSP: dockerls
        "docker-compose-language-service", -- LSP: docker-compose.yml

        -- Terraform / IaC
        "terraform-ls", -- LSP: terraformls + validation

        -- Go
        "gopls", -- LSP: full Go support
        "gofumpt", -- Formatter: stricter gofmt (conform.nvim)
        "golangci-lint", -- Linter: 100+ Go linters (nvim-lint)
        "delve", -- DAP: Go debugger

        -- Python
        "pyright", -- LSP: fast, static type checking
        "debugpy", -- DAP: Python debugger
        "black", -- Formatter: opinionated (conform.nvim)
        "isort", -- Formatter: import sorting (conform.nvim)
        "ruff", -- Linter: ultra-fast, fixes too (nvim-lint)

        -- Lua (Neovim config) – Use LazyVim defaults (stylua, luacheck via conform/nlint)
        -- "lua-language-server", -- LSP: lua_ls
        -- "stylua", -- Formatter: clean Lua
        -- "luacheck", -- Linter: style + errors

        -- Web / Frontend
        "eslint_d", -- Linter: JS/TS (daemon = fast) (nvim-lint)
      },

      -- Auto-update & install behavior
      auto_update = true, -- Keep tools current
      run_on_start = true, -- Install missing tools on launch
      start_delay = 3000, -- Wait 3s for Mason to init
      debounce_hours = 5, -- Don't check more than every 5h
    },
    config = function(_, opts)
      require("mason-tool-installer").setup(opts)
    end,
  },

  --=====================================================================
  -- 3. mason-lspconfig: Connect Mason → nvim-lspconfig
  --=====================================================================
  -- Repo: https://github.com/mason-org/mason-lspconfig.nvim
  -- Ensures LSP servers are installed and available to `lspconfig`
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = { "mason-org/mason.nvim" },
    event = "BufReadPre", -- Load when opening files
    opts = {
      -- Only LSP servers (not formatters/linters)
      ensure_installed = {
        "gopls",
        "pyright",
        "bashls",
        "yamlls",
        "dockerls",
        "terraformls",
        "jsonls",
        -- "lua_ls", -- Use LazyVim default
      },
      automatic_installation = true, -- Install if missing
    },
    config = function(_, opts)
      require("mason-lspconfig").setup(opts)
    end,
  },

  --=====================================================================
  -- Note: No mason-null-ls (removed for LazyVim defaults)
  --=====================================================================
  -- LazyVim uses conform.nvim (format) + nvim-lint (lint) by default
  -- Tools from mason-tool-installer are auto-detected
  -- If using none-ls.nvim: Enable extras.lsp.none-ls extra
  -- Otherwise: Remove any none-ls specs from your config
}
