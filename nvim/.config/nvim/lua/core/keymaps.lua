local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Better window navigation
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- Resize windows
map("n", "<C-Up>", "<cmd>resize +2<CR>", opts)
map("n", "<C-Down>", "<cmd>resize -2<CR>", opts)
map("n", "<C-Left>", "<cmd>vertical resize -2<CR>", opts)
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", opts)

-- Better indenting
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

-- Move lines
map("v", "J", ":m '>+1<CR>gv=gv", opts)
map("v", "K", ":m '<-2<CR>gv=gv", opts)

-- Keep cursor centered when jumping
map("n", "n", "nzzzv", opts)
map("n", "N", "Nzzzv", opts)

-- Quick save
map({ "n", "x" }, "<leader>w", "<cmd>write<CR>", opts)
map({ "n", "x" }, "<leader>q", "<cmd>quit<CR>", opts)
map({ "n", "x" }, "<leader>qq", "<cmd>qa!<CR>", opts)

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<CR>", opts)

-- Terminal mode: escape + close + window navigation
map("t", "<Esc><Esc>", "<C-\\><C-n>", opts)
map("t", "<c-/>", "<C-\\><C-n><cmd>close<CR>", opts)
map("t", "<C-h>", "<C-\\><C-n><C-w>h", opts)
map("t", "<C-j>", "<C-\\><C-n><C-w>j", opts)
map("t", "<C-k>", "<C-\\><C-n><C-w>k", opts)
map("t", "<C-l>", "<C-\\><C-n><C-w>l", opts)

-- File explorer (snacks)
map("n", "<leader>e", function() Snacks.explorer() end, opts)

-- Diagnostic navigation
map("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, opts)
map("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end, opts)
map("n", "<leader>d", vim.diagnostic.open_float, opts)
map("n", "gy", function()
  local diags = vim.diagnostic.get(0, { lnum = vim.fn.line(".") - 1 })
  if #diags > 0 then
    vim.fn.setreg("+", diags[1].message)
    vim.notify("Diagnostic copied", vim.log.levels.INFO)
  end
end, { desc = "Yank diagnostic at cursor" })
