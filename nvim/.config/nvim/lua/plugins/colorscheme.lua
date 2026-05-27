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
        cmp = true,
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
        "Normal",           -- Main editor background
        "NormalNC",         -- Non-focused windows
        "NormalFloat",      -- Floating windows (snacks picker/explorer)
        "SignColumn",       -- Git signs column
        "LineNr",           -- Line numbers
        "Folded",           -- Folded lines
        "EndOfBuffer",      -- ~ lines at end
        "VertSplit",        -- Vertical split
      }
      
      -- Apply transparency only to selected groups
      for _, group in ipairs(transparent_groups) do
        vim.api.nvim_set_hl(0, group, { bg = "none" })
      end
      
       -- Enhance Visual mode for better visibility on transparent background
       vim.api.nvim_set_hl(0, "Visual", {
         bg = "#45475a",    -- Catppuccin mocha surface0 with good contrast
         fg = "NONE",       -- Preserve syntax highlighting
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
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
