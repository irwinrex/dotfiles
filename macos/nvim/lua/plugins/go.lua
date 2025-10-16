return {
  "ray-x/go.nvim",
  dependencies = {
    "ray-x/guihua.lua",
    "neovim/nvim-lspconfig",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    require("go").setup({
      goimport = "gopls",
      gofmt = "gofumpt",
      max_line_len = 120,
      tag_transform = false,
      test_dir = "",
      comment_placeholder = "",
      lsp_cfg = false, -- use lspconfig instead
      lsp_gofumpt = true,
      lsp_on_attach = false, -- use our own on_attach
      dap_debug = true,
    })
  end,
  event = { "CmdlineEnter" },
  ft = { "go", "gomod" },
}
