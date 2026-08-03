return {
  {
    "catppuccin/nvim",
    lazy = false,
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "macchiato",
      background = {
        light = "latte",
        dark = "macchiato",
      },
      transparent_background = true,
      float = {
        transparent = false,
        solid = true,
      },
      term_colors = true,
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
      lsp_styles = {
        virtual_text = {
          errors = { "italic" },
          hints = { "italic" },
          warnings = { "italic" },
          information = { "italic" },
          ok = { "italic" },
        },
        underlines = {
          errors = { "undercurl" },
          hints = { "undercurl" },
          warnings = { "undercurl" },
          information = { "undercurl" },
          ok = { "undercurl" },
        },
        inlay_hints = { background = false },
      },
      auto_integrations = true,
      integrations = {
        blink_cmp = { enabled = true, style = "bordered" },
        gitsigns = { enabled = true, transparent = true },
        mini = { enabled = true, indentscope_color = "lavender" },
        snacks = { enabled = true, indent_scope_color = "lavender" },
      },
      highlight_overrides = {
        all = function(colors)
          local highlights = {
            -- A transparent canvas with clear focus and selection states.
            CursorLine = { bg = colors.surface0 },
            CursorLineNr = { fg = colors.lavender, bg = colors.surface0, bold = true },
            CursorLineSign = { bg = colors.surface0 },
            LineNr = { fg = colors.surface1 },
            Visual = { bg = colors.surface1 },
            VisualNOS = { bg = colors.surface1 },
            MatchParen = { fg = colors.peach, bold = true, underline = true },
            Search = { fg = colors.base, bg = colors.yellow, bold = true },
            IncSearch = { fg = colors.crust, bg = colors.peach, bold = true },
            CurSearch = { fg = colors.crust, bg = colors.red, bold = true },

            -- Solid floating surfaces sit above the transparent editor.
            NormalFloat = { fg = colors.text, bg = colors.mantle },
            FloatBorder = { fg = colors.surface2, bg = colors.mantle },
            FloatTitle = { fg = colors.lavender, bg = colors.mantle, bold = true },
            Pmenu = { fg = colors.subtext1, bg = colors.mantle },
            PmenuSel = { fg = colors.text, bg = colors.surface1, bold = true },
            PmenuMatch = { fg = colors.mauve, bold = true },
            WinSeparator = { fg = colors.surface1 },

            -- The explorer is a transparent sidebar; other pickers stay solid.
            SnacksExplorerNormal = { fg = colors.text, bg = colors.none },
            SnacksExplorerBorder = { fg = colors.surface1, bg = colors.none },
            SnacksExplorerTitle = { fg = colors.lavender, bg = colors.none, bold = true },
            SnacksExplorerCursorLine = { bg = colors.surface0, bold = true },

            -- Reusable Snacks surfaces keep transparency independent of focus.
            SnacksTransparentNormal = { fg = colors.text, bg = colors.none },
            SnacksTransparentBorder = { fg = colors.surface1, bg = colors.none },
            SnacksTransparentTitle = { fg = colors.lavender, bg = colors.none, bold = true },

            -- Popup utilities remain readable cards above the transparent canvas.
            SnacksSolidNormal = { fg = colors.text, bg = colors.mantle },
            SnacksSolidBorder = { fg = colors.surface2, bg = colors.mantle },
            SnacksSolidTitle = { fg = colors.lavender, bg = colors.mantle, bold = true },
            SnacksInputNormal = { fg = colors.text, bg = colors.mantle },
            SnacksInputBorder = { fg = colors.blue, bg = colors.mantle },
            SnacksInputTitle = { fg = colors.blue, bg = colors.mantle, bold = true },
            SnacksNotifierHistory = { fg = colors.text, bg = colors.mantle },
            SnacksPickerBufPin = { fg = colors.peach, bold = true },

            -- Quiet chrome keeps attention on code, with lavender as the accent.
            Comment = { fg = colors.overlay1, italic = true },
            Folded = { fg = colors.blue, bg = colors.surface0, italic = true },
            NonText = { fg = colors.surface1 },
            Whitespace = { fg = colors.surface0 },
            Directory = { fg = colors.blue, bold = true },
            Title = { fg = colors.mauve, bold = true },
            QuickFixLine = { bg = colors.surface0, bold = true },
            GitSignsCurrentLineBlame = { fg = colors.overlay1, italic = true },

            -- Shared accents for the custom statusline.
            StatusLine = { fg = colors.subtext1, bg = colors.mantle },
            StatusLineNC = { fg = colors.overlay0, bg = colors.mantle },
            StatusLineAccent = { fg = colors.crust, bg = colors.mauve, bold = true },
            StatusLineMuted = { fg = colors.overlay1, bg = colors.mantle },
            TabLine = { fg = colors.overlay1, bg = colors.mantle },
            TabLineFill = { fg = colors.surface1, bg = colors.mantle },
            TabLineSel = { fg = colors.crust, bg = colors.mauve, bold = true },
            BufferTabPinned = { fg = colors.peach, bg = colors.mantle, bold = true },
            BufferTabPinnedSel = { fg = colors.crust, bg = colors.mauve, bold = true },
            BufferTabDiagnosticError = { fg = colors.red, bg = colors.mantle, bold = true },
            BufferTabDiagnosticWarn = { fg = colors.yellow, bg = colors.mantle, bold = true },
            BufferTabDiagnosticErrorSel = { fg = colors.red, bg = colors.mauve, bold = true },
            BufferTabDiagnosticWarnSel = { fg = colors.crust, bg = colors.mauve, bold = true },
          }

          local notifier_colors = {
            Debug = colors.peach,
            Error = colors.red,
            Info = colors.blue,
            Trace = colors.rosewater,
            Warn = colors.yellow,
          }
          for level, color in pairs(notifier_colors) do
            highlights["SnacksNotifier" .. level] = { fg = color, bg = colors.mantle }
            highlights["SnacksNotifierBorder" .. level] = { fg = color, bg = colors.mantle }
            highlights["SnacksNotifierFooter" .. level] = { fg = color, bg = colors.mantle }
            highlights["SnacksNotifierTitle" .. level] = { fg = color, bg = colors.mantle, italic = true }
          end

          return highlights
        end,
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin-nvim")
    end,
  },
}
