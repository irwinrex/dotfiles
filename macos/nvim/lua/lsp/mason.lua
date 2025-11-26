return {
  -- Mason installer
  {
    "mason-org/mason.nvim",
    opts = {
      ui = { border = "rounded" },
    },
  },

  -- Mason‑LSPConfig to auto‑install LSP servers
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        -- core languages
        "pyright", -- Python
        "gopls", -- Go

        -- markup / web / config / infra
        "html", -- HTML
        "cssls", -- CSS
        "jsonls", -- JSON
        "yamlls", -- YAML
        "typescript-language-server", -- Sometimes used by mason, but LSP name is tsserver
        "tsserver", -- JavaScript / TypeScript
        "marksman", -- Markdown
        "terraformls", -- Terraform

        -- shells / scripting
        "bashls", -- Bash / shell scripts
      },
    },
  },

  -- LSP config (if needed — but LazyVim usually ships this)
  -- {
  --   "neovim/nvim-lspconfig",
  -- },
}
