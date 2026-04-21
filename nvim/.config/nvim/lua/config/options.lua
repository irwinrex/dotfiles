-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

-- Better diff view
vim.opt.diffopt:append({
  "internal",
  "filler",
  "closeoff",
  "indent-heuristic",
  "algorithm:histogram",
})

if vim.fn.has("nvim-0.9") == 1 then
  vim.opt.diffopt:append({ "linematch:60" })
end

-- Editor behavior
vim.opt.autoread = true
vim.opt.backspace = { "indent", "eol", "start" }
vim.opt.clipboard = "unnamedplus"
vim.opt.mouse = "a"
vim.opt.swapfile = false
vim.opt.writebackup = false

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- UI
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.breakindent = true
vim.opt.showmode = false
vim.opt.cmdheight = 1

-- Completion
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.shortmess:append("c")

-- Splits
vim.opt.splitright = true
vim.opt.splitbelow = true

-- LSP
vim.g.lazyvim_lsp_inlay_hints = false

-- Performance
vim.opt.lazyredraw = false
vim.opt.synmaxcol = 240
