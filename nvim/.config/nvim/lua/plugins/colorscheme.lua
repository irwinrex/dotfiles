return {
  -- Modern Catppuccin configuration following LazyVim Starter practices
  {
    "catppuccin/nvim",
    lazy = false,
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "mocha",
      transparent_background = true,
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
      integrations = {
        aerial = true,
        alpha = true,
        bufferline = true,
        blink_cmp = true,
        dashboard = true,
        flash = true,
        gitsigns = true,
        headlines = true,
        illuminate = true,
        indent_blankline = { enabled = true },
        leap = true,
        lsp_trouble = true,
        mason = true,
        markdown = true,
        mini = true,
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
        navic = { enabled = true, custom_bg = "lualine" },
        neotest = true,
        noice = true,
        notify = true,
        semantic_tokens = true,
        snacks = true,
        telescope = true,
        treesitter = true,
        treesitter_context = true,
        which_key = true,
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin")

      -- Selective transparency: keep backgrounds for UI elements that need contrast
      local transparent_groups = {
        "Normal",              -- Main editor background
        "NormalNC",            -- Non-focused windows
        "NormalFloat",         -- Floating windows (snacks picker/explorer)
        "FloatBorder",         -- Floating window borders
        "SignColumn",          -- Git signs column
        "LineNr",              -- Line numbers
        "CursorLineNr",        -- Active line number
        "Folded",              -- Folded lines
        "EndOfBuffer",         -- ~ lines at end
        "VertSplit",           -- Vertical split
        "Pmenu",               -- Completion menu
        "PmenuSel",            -- Selected completion item
        "WhichKeyFloat",       -- Which-key popup
        "WhichKeyBorder",      -- Which-key border
        "BlinkCmpDoc",         -- Blink documentation window
        "BlinkCmpDocBorder",   -- Blink documentation border
        "LazyNormal",          -- Lazy.nvim UI
        "LazyFloat",           -- Lazy.nvim floating window
        "MasonNormal",         -- Mason window
        "NoicePopup",          -- Noice popup
        "NoiceCmdlinePopup",   -- Noice cmdline popup
        "NotifyBackground",    -- Notify background
      }

      -- Apply transparency only to selected groups
      for _, group in ipairs(transparent_groups) do
        local ok, _ = pcall(vim.api.nvim_set_hl, 0, group, { bg = "none" })
      end

       -- Enhance selection/UI visibility on transparent background
       vim.api.nvim_set_hl(0, "Visual", {
         bg = "#45475a",
         fg = "NONE",
       })
       vim.api.nvim_set_hl(0, "VisualNOS", {
         bg = "#45475a",
         fg = "NONE",
       })

       -- Improve visibility of key syntax elements on transparent background
       local hl = vim.api.nvim_set_hl
      hl(0, "Comment", { fg = "#6c7086", italic = true })    -- Brighter comments
      hl(0, "String", { fg = "#f5a97f" })                    -- Warm strings
      hl(0, "Function", { fg = "#89b4fa", bold = true })     -- Clear functions
      hl(0, "Keyword", { fg = "#f38ba8", italic = true })    -- Distinct keywords
      hl(0, "Type", { fg = "#a6e3a1", bold = true })         -- Visible types
      hl(0, "Constant", { fg = "#f9e2af" })                  -- Readable constants
      hl(0, "Identifier", { fg = "#cdd6f4" })                -- Clear variables
      hl(0, "Statement", { fg = "#f38ba8" })                 -- Better statements

      -- Re-apply transparency to Snacks windows after all plugins load
      vim.api.nvim_create_autocmd("UIEnter", {
        once = true,
        callback = function()
          local snacks_groups = {
            "SnacksNormal",
            "SnacksNormalNC",
            "SnacksBackdrop",
            "SnacksTerminal",
            "SnacksTerminalBorder",
            "SnacksPicker",
            "SnacksPickerBorder",
            "SnacksExplorer",
            "SnacksExplorerBorder",
            "SnacksInput",
            "SnacksInputBorder",
            "SnacksScratch",
            "SnacksScratchBorder",
            "SnacksTitle",
            "SnacksFooter",
            "SnacksWinBar",
            "SnacksWinBarNC",
            "SnacksWinSeparator",
            "SnacksWinKey",
            "SnacksWinKeySep",
            "SnacksWinKeyDesc",
            "SnacksFooterDesc",
            "SnacksFooterKey",
          }
          for _, group in ipairs(snacks_groups) do
            pcall(vim.api.nvim_set_hl, 0, group, { bg = "none" })
          end
        end,
      })
    end,
  },
}
