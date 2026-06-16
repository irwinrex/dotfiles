return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    ensure_installed = { "terraform", "hcl" },
    auto_install = true,
    highlight = { enable = true },
  },
}
