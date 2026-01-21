-- Diagnostics: quiet, deliberate, signal-only

vim.diagnostic.config({
  virtual_text = false, -- no inline noise
  signs = true, -- gutter indicators only
  underline = true, -- underline actual problems
  update_in_insert = false, -- no flicker while typing
  severity_sort = true, -- errors first
})

-- On-demand diagnostic popup (cursor-scoped)
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Diagnostics (float)" })
