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
}
