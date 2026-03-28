-- Autocmds are automatically loaded on the VeryLazy event

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
})

-- Remove trailing whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("trim_whitespace", { clear = true }),
  pattern = "*",
  command = [[%s/\s\+$//e]],
})

-- Auto-resize splits on window resize
vim.api.nvim_create_autocmd("VimResized", {
  group = vim.api.nvim_create_augroup("resize_splits", { clear = true }),
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

-- Close quickfix/location list when leaving window
vim.api.nvim_create_autocmd("WinLeave", {
  group = vim.api.nvim_create_augroup("close_qf", { clear = true }),
  pattern = "*",
  callback = function()
    if vim.bo.filetype == "qf" then
      vim.cmd("cclose")
    end
  end,
})

-- Restore cursor position on file open
vim.api.nvim_create_autocmd("BufReadPost", {
  group = vim.api.nvim_create_augroup("restore_cursor", { clear = true }),
  pattern = "*",
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Enable spell checking for certain file types
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("spell_check", { clear = true }),
  pattern = { "gitcommit", "markdown", "text" },
  callback = function()
    vim.opt_local.spell = true
  end,
})

-- Save and reload view on file open
vim.api.nvim_create_autocmd("BufWinLeave", {
  group = vim.api.nvim_create_augroup("save_view", { clear = true }),
  pattern = "*",
  callback = function()
    if vim.bo.modifiable and vim.fn.expand("%") ~= "" then
      vim.cmd("silent! mkview")
    end
  end,
})

vim.api.nvim_create_autocmd("BufWinEnter", {
  group = vim.api.nvim_create_augroup("load_view", { clear = true }),
  pattern = "*",
  callback = function()
    if vim.fn.exists("v:oldfold") == 0 and vim.fn.expand("%") ~= "" then
      vim.cmd("silent! loadview")
    end
  end,
})
