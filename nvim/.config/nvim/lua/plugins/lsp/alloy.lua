-- ~/.config/nvim/lua/plugins/language/alloy.lua

return {
  {
    "grafana/vim-alloy",
    ft = "alloy",
    init = function()
      vim.filetype.add({
        extension = {
          alloy = "alloy",
        },
      })
    end,
  },
}
