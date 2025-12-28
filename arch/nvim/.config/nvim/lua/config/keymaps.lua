-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- Custom keymaps
vim.keymap.set("n", "<leader>gs", vim.cmd.Git, { desc = "Git status" })
