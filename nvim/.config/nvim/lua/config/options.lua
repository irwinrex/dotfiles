-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
-- vim.opt.relativenumber = false
-- Disable true color — use terminal's 16 ANSI colors instead
vim.opt.termguicolors = false

-- Diff options
vim.opt.diffopt:append({
  "internal",
  "filler",
  "closeoff",
  "indent-heuristic",
  "algorithm:histogram",
})

-- linematch only available in nvim 0.9+
if vim.fn.has("nvim-0.9") == 1 then
  vim.opt.diffopt:append({ "linematch:60" })
end
