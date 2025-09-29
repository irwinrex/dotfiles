return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        filtered_items = {
          visible = true, -- Show hidden files
          hide_dotfiles = false, -- Do not hide dotfiles
          hide_gitignored = false, -- Do not hide git-ignored files
        },
      },
    },
  },
}
