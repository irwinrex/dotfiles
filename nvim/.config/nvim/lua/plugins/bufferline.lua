return {
  "akinsho/bufferline.nvim",
  event = "VeryLazy",
  keys = {
    { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
    { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
    { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
    { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
    { "<leader>bj", "<cmd>BufferLinePick<cr>", desc = "Pick Buffer" },
    { "<leader>bp", "<cmd>BufferLineTogglePin<cr>", desc = "Toggle Pin" },
    { "<leader>bP", "<cmd>BufferLineGroupClose ungrouped<cr>", desc = "Delete Non-Pinned Buffers" },
    { "<leader>br", "<cmd>BufferLineCloseRight<cr>", desc = "Delete Buffers to the Right" },
    { "<leader>bl", "<cmd>BufferLineCloseLeft<cr>", desc = "Delete Buffers to the Left" },
  },
  opts = {
    options = {
      close_command = function(n) require("snacks").bufdelete(n) end,
      right_mouse_command = function(n) require("snacks").bufdelete(n) end,
      diagnostics = "nvim_lsp",
      always_show_bufferline = true,
      separator_style = "thin",
      numbers = "ordinal",
      color_icons = true,
      maximum_padding = 2,
      diagnostics_indicator = function(_, _, diag)
        local icons = { error = " ", warn = " ", info = " ", hint = "󰌶 " }
        local ret = (diag.error and icons.error .. diag.error .. " " or "")
          .. (diag.warning and icons.warn .. diag.warning or "")
        return vim.trim(ret)
      end,
      offsets = {
        { filetype = "neo-tree", text = " Explorer", highlight = "Directory", text_align = "left" },
        { filetype = "snacks_layout_box", text = "Snacks", highlight = "Directory", text_align = "left" },
      },
    },
  },
  config = function(_, opts)
    require("bufferline").setup(opts)

    vim.api.nvim_set_hl(0, "BufferLineBufferSelected", { fg = "#89b4fa", bold = true })
    vim.api.nvim_set_hl(0, "BufferLineBuffer", { fg = "#585b70" })
    vim.api.nvim_set_hl(0, "BufferLineBufferVisible", { fg = "#6c7086" })
    vim.api.nvim_set_hl(0, "BufferLineNumbersSelected", { fg = "#89b4fa", bold = true })
    vim.api.nvim_set_hl(0, "BufferLineNumbers", { fg = "#585b70" })
    vim.api.nvim_set_hl(0, "BufferLineNumbersVisible", { fg = "#6c7086" })
    vim.api.nvim_set_hl(0, "BufferLineSeparator", { fg = "#1e1e2e" })
    vim.api.nvim_set_hl(0, "BufferLineSeparatorSelected", { fg = "#1e1e2e" })
    vim.api.nvim_set_hl(0, "BufferLineSeparatorVisible", { fg = "#1e1e2e" })
  end,
}
