-- Enable true colors
vim.o.termguicolors = true

-- Detect terminal background if set
if vim.env.TERM_BACKGROUND == "light" then
  vim.o.background = "light"
else
  vim.o.background = "dark"
end

-- Bootstrap lazy.nvim (your existing code)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Configure lazy.nvim
require("lazy").setup({
  spec = {
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    { import = "plugins" },
    { import = "plugins.lsp" },
  },

  defaults = {
    lazy = false,
    version = false,
  },

  -- Pick a colorscheme depending on terminal background
  install = {
    colorscheme = (vim.o.background == "light") and { "habamax" } or { "catppuccin" }
  },

  checker = { enabled = true, notify = false },

  performance = {
    rtp = {
      disabled_plugins = { "gzip", "tarPlugin", "tohtml", "tutor", "zipPlugin" },
    },
  },
})
