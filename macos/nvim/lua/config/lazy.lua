-- Bootstrap lazy.nvim
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
  -- Plugin specification
  spec = {
    -- 1. LazyVim's core plugins
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },

    -- 2. Your custom configurations (must be loaded last)
    { import = "plugins" },
  },

  -- Default plugin options
  defaults = {
    lazy = false, -- Load custom plugins eagerly
    version = false, -- Use latest commit, not tagged releases
  },

  -- Automatically install a colorscheme on startup
  install = { colorscheme = { "catppuccin", "habamax" } },

  -- Plugin update checker settings
  checker = {
    enabled = true,
    notify = false, -- Don't show notifications for updates
  },

  -- Performance optimizations
  performance = {
    rtp = {
      -- Disable unneeded built-in plugins
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
