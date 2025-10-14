-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- Indentation
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2

-- Other nice defaults
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true

-- Insert mode
vim.keymap.set("i", "<C-s>", "<C-w>", { noremap = true, silent = true })
-- Normal mode (optional)
vim.keymap.set("n", "<C-s>", "db", { noremap = true, silent = true })
