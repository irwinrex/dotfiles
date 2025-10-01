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

-- Copyright (c) 2025 Author. All Rights Reserved.
vim.api.nvim_set_keymap("i", "jj", "<Esc>", { noremap = false })
