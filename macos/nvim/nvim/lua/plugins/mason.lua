-- ~/.config/nvim/lua/plugins/mason.lua
return {
  {
    "mason-org/mason.nvim",
    dependencies = {
      "mason-org/mason-lspconfig.nvim", -- Optional, but recommended
    },
    opts = {
      -- UI icons
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
      -- Tools to auto-install (LSPs, formatters, linters, DAP)
      ensure_installed = {
        -- === LSP Servers (use EXACT mason package names) ===
        "gopls",
        "basedpyright", -- or "pyright"
        "bash-language-server",
        "yaml-language-server",
        "dockerfile-language-server",
        "terraform-ls",
        "typescript-language-server", -- maps to ts_ls in lspconfig
        "json-lsp",
        "lua-language-server",

        -- === Formatters ===
        "gofumpt",
        "ruff", -- Python formatter + linter
        "shfmt",
        "prettier",

        -- === Linters ===
        "golangci-lint",
        "shellcheck",
        "yamllint",
        "hadolint",
        "eslint_d",

        -- === Debug Adapters (DAP) ===
        "delve", -- Go
        "debugpy", -- Python
      },
    },
  },

  -- Optional: Bridge to nvim-lspconfig (recommended)
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      -- Only LSP server names from `nvim-lspconfig`
      ensure_installed = {
        "gopls",
        "basedpyright",
        "bashls", -- maps from bash-language-server
        "yamlls",
        "dockerls",
        "terraformls",
        "ts_ls", -- maps from typescript-language-server
        "jsonls",
        "lua_ls",
      },
      automatic_installation = true,
    },
  },
}
