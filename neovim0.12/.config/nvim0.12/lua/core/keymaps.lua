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
map("n", "J", "mzJ`z", opts)

-- Quick save
map({ "n", "x" }, "<leader>w", "<cmd>write<CR>", opts)
map({ "n", "x" }, "<leader>q", "<cmd>quit<CR>", opts)

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<CR>", opts)

-- Better escape from terminal mode
map("t", "<Esc><Esc>", "<C-\\><C-n>", opts)

-- File explorer (netrw)
map("n", "<leader>e", "<cmd>Explore<CR>", opts)

-- Diagnostic navigation
map("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, opts)
map("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end, opts)
map("n", "<leader>d", vim.diagnostic.open_float, opts)
