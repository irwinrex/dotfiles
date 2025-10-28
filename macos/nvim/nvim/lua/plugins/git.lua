-- ~/.config/nvim/lua/plugins/git.lua
return {
  -- Gitsigns: inline Git info
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        current_line_blame = true, -- show inline blame
        signs = {
          add = { text = "+" },
          change = { text = "~" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
        },
      })
    end,
  },

  -- Optional: lazygit integration
  {
    "kdheepak/lazygit.nvim",
    config = function()
      vim.api.nvim_set_keymap("n", "<leader>gg", ":LazyGit<CR>", { noremap = true, silent = true })
    end,
  },
}
