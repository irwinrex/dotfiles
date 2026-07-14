return {
  {
    "MagicDuck/grug-far.nvim",
    cmd = "GrugFar",
    keys = {
      {
        "<leader>sr",
        function()
          local grug = require("grug-far")
          local word = vim.fn.expand("<cword>")
          grug.open({ prefills = { search = word } })
        end,
        desc = "Search and Replace (Grug Far)",
      },
    },
    opts = {
      engine = "ripgrep",
      showHiddenFiles = true,
    },
  },
}
