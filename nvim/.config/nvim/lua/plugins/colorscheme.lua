return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "auto",
      background = {
        dark = "mocha",
        light = "latte",
      },
      transparent_background = true,
      show_end_of_buffer = false,
      term_colors = true,
      dim_inactive = {
        enabled = false,
      },
      styles = {
        comments = { "italic" },
        conditionals = { "italic" },
        loops = {},
        functions = { "bold" },
        keywords = { "italic" },
        strings = {},
        variables = {},
        numbers = {},
        booleans = { "bold" },
        properties = {},
        types = { "bold" },
        operators = {},
      },
      auto_integrations = false,
      integrations = {
        cmp = true,
        gitsigns = true,
        treesitter = true,
        which_key = true,
        indent_blankline = { enabled = true },
        noice = true,
        snacks = true,
        neo_tree = true,
        telescope = { enabled = true },
        flash = true,
        trouble = true,
        notify = true,
      },
      custom_highlights = function(colours)
        return {
          -- Buffer line
          TabLineFill = { bg = colours.surface0 },
          TabLineSel = { bg = colours.mantle },
          -- Float windows
          NormalFloat = { bg = colours.surface0 },
          FloatBorder = { fg = colours.surface0, bg = colours.surface0 },
          -- Diagnostic
          DiagnosticError = { fg = colours.red },
          DiagnosticWarn = { fg = colours.yellow },
          DiagnosticHint = { fg = colours.sky },
          DiagnosticInfo = { fg = colours.blue },
          -- Quickfix
          qfFileName = { fg = colours.blue },
          qfLineNr = { fg = colours.overlay1 },
          -- Cursor
          Cursor = { bg = colours.fg, fg = colours.base },
          CursorLineNr = { fg = colours.text, bold = true },
          -- Misc
          LineNr = { fg = colours.overlay0 },
          CursorLine = { bg = colours.surface0 },
          VertSplit = { fg = colours.surface1, bg = colours.base },
          StatusLine = { fg = colours.text, bg = colours.surface0 },
          StatusLineNC = { fg = colours.overlay0, bg = colours.surface0 },
          WinBar = { fg = colours.overlay0, bg = colours.base },
          WinBarNC = { fg = colours.overlay1, bg = colours.base },
        }
      end,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
