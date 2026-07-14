return {
  "folke/flash.nvim",
  keys = {
    { "s", function() require("flash").jump() end, mode = { "n", "x", "o" }, desc = "Flash jump" },
  },
  opts = {},
}
