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

-- Terraform filetype detection
vim.filetype.add({
  extension = {
    tf = "terraform",
    tfvars = "terraform",
    hcl = "hcl",
  },
})

-- Auto-reload files when modified externally
augroup("AutoReload", { clear = true })
autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  group = "AutoReload",
  command = "if mode() != 'c' | checktime | endif",
})

autocmd("FileChangedShellPost", {
  group = "AutoReload",
  callback = function()
    vim.notify("File changed on disk. Buffer reloaded.", vim.log.levels.WARN)
  end,
})

-- Format and organize imports on save via gopls
augroup("GoFormat", { clear = true })
autocmd("BufWritePre", {
  group = "GoFormat",
  pattern = "*.go",
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    local client = vim.lsp.get_clients({ bufnr = bufnr, name = "gopls" })[1]
    if not client then
      return
    end

    local params = {
      textDocument = { uri = vim.uri_from_bufnr(bufnr) },
      range = {
        start = { line = 0, character = 0 },
        ["end"] = { line = vim.api.nvim_buf_line_count(bufnr), character = 0 },
      },
      context = { diagnostics = {}, only = { "source.organizeImports" } },
    }
    local ok, response = pcall(client.request_sync, client, "textDocument/codeAction", params, 5000, bufnr)
    if ok and response and response.result then
      local actions = response.result
      if type(actions) == "table" and actions[1] and actions[1].edit then
        vim.lsp.util.apply_workspace_edit(actions[1].edit, client.offset_encoding)
      end
    end

    vim.lsp.buf.format({ bufnr = bufnr, name = "gopls", async = false })
  end,
})
