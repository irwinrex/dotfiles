return {
  "grafana/vim-alloy",
  -- Optional: Set up filetype detection and enable syntax highlighting
  ft = "alloy", -- Lazy-load only when an Alloy file is opened
  config = function()
    -- Enable syntax highlighting for Alloy files
    vim.cmd("syntax enable")
  end,
}
