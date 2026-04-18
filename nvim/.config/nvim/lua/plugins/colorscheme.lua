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
        enabled = true,
        shade = "dark",
        percentage = 0.15,
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
      auto_integrations = true,
      integrations = {
        aerial = true,
        alpha = true,
        cmp = true,
        dashboard = true,
        flash = true,
        fzf = true,
        grug_far = true,
        gitsigns = true,
        illuminate = { enabled = true },
        indent_blankline = { enabled = true },
        leap = true,
        lsp_trouble = true,
        mason = true,
        mini = { enabled = true },
        navic = { enabled = true, custom_bg = "lualine" },
        neotest = true,
        neo_tree = true,
        noice = true,
        notify = true,
        snacks = true,
        telescope = { enabled = true },
        treesitter = true,
        treesitter_context = true,
        which_key = true,
        lsp_styles = {
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
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
