return {
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
    dependencies = { "mason.nvim" },
    opts = {
      ensure_installed = {
        "basedpyright",
        "gopls",
        "jsonls",
        "lua_ls",
        "terraformls",
        "yamlls",
      },
      handlers = {},
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    event = "VeryLazy",
    dependencies = { "mason.nvim" },
    opts = {
      ensure_installed = {
        "gofumpt",
        "goimports",
      },
    },
  },
}
