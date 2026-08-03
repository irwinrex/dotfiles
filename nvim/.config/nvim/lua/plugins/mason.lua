return {
  {
    -- Provides the default cmd, filetypes, and root markers used by
    -- vim.lsp.config() for each language server.
    "neovim/nvim-lspconfig",
    lazy = false,
  },
  {
    "williamboman/mason.nvim",
    event = "VeryLazy",
    build = ":MasonUpdate",
    cmd = "Mason",
    opts = {},
  },
  {
    "williamboman/mason-lspconfig.nvim",
    event = "VeryLazy",
    dependencies = { "mason.nvim", "neovim/nvim-lspconfig" },
    opts = {
      ensure_installed = {
        "basedpyright",
        "gopls",
        "jsonls",
        "lua_ls",
        "ruff",
        "terraformls",
        "yamlls",
      },
      -- Servers are configured and enabled explicitly in lua/lsp/lang.
      automatic_enable = false,
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    event = "VeryLazy",
    dependencies = { "mason.nvim" },
    opts = {
      ensure_installed = {
        "prettier",
        "stylua",
      },
    },
  },
}
