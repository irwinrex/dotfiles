-- Ensure mason-managed LSP binaries are in PATH
local data_path = vim.fn.stdpath("data")
vim.env.PATH = data_path .. "/mason/bin:" .. vim.env.PATH

-- Core
require("core.options")
require("core.keymaps")
require("core.autocmds")

-- LSP
require("lsp")

-- Plugins
require("plugins.treesitter")
require("plugins.blink")
require("plugins.conform")
require("plugins.gitsigns")
require("plugins.telescope")
require("plugins.flash")

-- UI
require("ui.statusline")

vim.cmd.colorscheme("habamax")
