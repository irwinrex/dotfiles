local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight yanked text
augroup("YankHighlight", { clear = true })
autocmd("TextYankPost", {
  group = "YankHighlight",
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
})

-- Strip trailing whitespace on save
augroup("StripTrailingWhitespace", { clear = true })
autocmd("BufWritePre", {
  group = "StripTrailingWhitespace",
  pattern = "*",
  callback = function()
    local save = vim.fn.winsaveview()
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.winrestview(save)
  end,
})

-- Auto-resize splits on window resize
augroup("AutoResize", { clear = true })
autocmd("VimResized", {
  group = "AutoResize",
  command = "tabdo wincmd =",
})

-- Restore cursor position
augroup("RestoreCursor", { clear = true })
autocmd("BufReadPost", {
  group = "RestoreCursor",
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    if mark[1] > 0 and mark[1] <= vim.fn.line("$") then
      vim.api.nvim_win_set_cursor(0, mark)
    end
  end,
})

-- Spell check for git commits and markdown
augroup("SpellCheck", { clear = true })
autocmd("FileType", {
  group = "SpellCheck",
  pattern = { "gitcommit", "markdown", "text" },
  command = "setlocal spell",
})
