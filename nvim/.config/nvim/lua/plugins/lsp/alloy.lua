-- Grafana Alloy config
return {
  {
    "nvim-lua/plenary.nvim",
    lazy = true,
    init = function()
      vim.filetype.add({
        extension = {
          alloy = "alloy",
        },
        filename = {
          ["alloy"] = "alloy",
        },
        pattern = {
          [".*%.alloy"] = "alloy",
        },
      })
    end,
  },
  {
    "grafana/vim-alloy",
    ft = "alloy",
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        alloy = {},
      },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "alloy" })
    end,
  },
}
