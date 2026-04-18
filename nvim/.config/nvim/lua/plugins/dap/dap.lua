-- Debug Adapter Protocol (DAP) configuration
return {
  {
    "mfussenegger/nvim-dap",
    lazy = true,
    dependencies = {
      "williamboman/mason.nvim",
    },
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "debugpy",
        "delve",
        "dart-debug-adapter",
      })
    end,
  },
}
