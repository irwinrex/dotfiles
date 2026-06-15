vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.diffopt = "internal,filler,closeoff,indent-heuristic,algorithm:histogram,linematch:60"
vim.opt.autoread = true
vim.opt.backspace = { "indent", "eol", "start" }
vim.opt.clipboard = "unnamedplus"
vim.opt.mouse = "a"
vim.opt.swapfile = false
vim.opt.writebackup = false

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.breakindent = true
vim.opt.showmode = false
vim.opt.cmdheight = 1

vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.shortmess:append("c")

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.softtabstop = 2

vim.opt.lazyredraw = false
vim.opt.synmaxcol = 240

vim.opt.termguicolors = true
