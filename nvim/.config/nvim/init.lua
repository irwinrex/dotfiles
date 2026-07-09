-- Ensure mason-managed LSP and Go binaries are in PATH
local data_path = vim.fn.stdpath("data")
local go_path = vim.fn.expand("$HOME/go/bin")
vim.env.PATH = table.concat({ data_path .. "/mason/bin", go_path, vim.env.PATH }, ":")

-- Core
require("core.options")
require("core.keymaps")
require("core.autocmds")

-- Bootstrap lazy.nvim
local lazypath = data_path .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = { { import = "plugins" } },
  defaults = { lazy = true },
  install = { colorscheme = { "catppuccin" } },
  ui = { border = "rounded" },
})

-- LSP (needs blink.cmp from plugins — loaded via lazy=false)
require("lsp")

-- UI
require("ui.statusline")

vim.cmd.colorscheme("catppuccin")
