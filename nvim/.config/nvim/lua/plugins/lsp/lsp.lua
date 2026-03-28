-- LazyVim LSP override — DevOps stack
return {
  { "b0o/SchemaStore.nvim", lazy = true },

  {
    "mason-org/mason.nvim",
    opts = {
      ui = { border = "rounded" },
      ensure_installed = {
        "actionlint",
        "ansible-lint",
        "yamllint",
        "hadolint",
        "kube-linter",
        "prettier",
        "shfmt",
        "jsonlint",
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        groovy_ls = {},
        dockerls = {},
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = { globals = { "vim" } },
              workspace = { checkThirdParty = false },
              telemetry = { enable = false },
            },
          },
        },
      },
      setup = {},
    },
  },
}
