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

-- Buffer navigation
map("n", "H", "<cmd>bprevious<CR>", opts)
map("n", "L", "<cmd>bnext<CR>", opts)
map("n", "J", "<cmd>bmove +1<CR>", opts)
map("n", "K", "<cmd>bmove -1<CR>", opts)
map("n", "<leader>bd", function()
  vim.api.nvim_buf_delete(vim.api.nvim_get_current_buf(), { force = true })
end, opts)
map("n", "<leader>bp", function()
  local current = vim.api.nvim_get_current_buf()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if buf ~= current and vim.api.nvim_buf_is_loaded(buf) then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end
end, opts)

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
