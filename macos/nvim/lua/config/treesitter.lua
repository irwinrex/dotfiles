-- treesitter.lua
-- Treesitter configuration: syntax highlighting, indentation, folding, text objects
-- Uses latest main branch for up-to-date parsers (Neovim 0.10+ compatible)
-- Lazy-loaded with events; disables for large files (>100KB) to avoid lag
-- Essential for accurate highlighting in Go, Python, HCL (Terraform), YAML, etc.
-- Optional: textobjects for structural editing (e.g., af/if for functions)

return {
  --=====================================================================
  -- 1. Treesitter Core: Highlighting, Indent, Folds, Selection
  --=====================================================================
  -- Repo: https://github.com/nvim-treesitter/nvim-treesitter
  -- Powers modern syntax, incremental selection, and more
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main", -- Latest parsers (release tags are outdated)
    version = false, -- Ignore version pinning for bleeding-edge
    build = ":TSUpdate", -- Auto-update parsers
    event = { "BufReadPost", "BufNewFile" }, -- Lazy-load on file open
    opts = {
      -- Syntax highlighting (core feature)
      highlight = {
        enable = true,
        -- Disable for large files (performance safeguard)
        disable = function(_, bufnr)
          local max_filesize = 100 * 1024 -- 100 KB threshold
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(bufnr))
          return ok and stats and stats.size > max_filesize
        end,
      },

      -- Auto-indent based on language grammar
      indent = { enable = true },

      -- Code folding by structure (e.g., functions, blocks)
      folds = { enable = true },

      -- Incremental selection (grow/shrink by AST nodes)
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "gnn", -- Start selection
          node_incremental = "grn", -- Expand node
          scope_incremental = "grc", -- Expand scope
          node_decremental = "grm", -- Shrink node
        },
      },

      -- Install only your core languages (from chat: Go, Python, HCL/Terraform, YAML, Docker, Bash, JSON, Lua)
      ensure_installed = {
        "go",
        "python",
        "hcl",
        "yaml",
        "dockerfile",
        "bash",
        "json",
        "lua",
        -- Optional extras: "markdown", "sql" if needed
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  --=====================================================================
  -- 2. Treesitter Text Objects: Structural Editing (Optional)
  --=====================================================================
  -- Repo: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
  -- Enables af/if (function outer/inner), ac/ic (class), etc.
  -- Remove if you don't use these motions (saves ~1MB)
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    event = "VeryLazy", -- Load late
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      -- Selection: vi{af,if} for functions/classes
      select = {
        enable = true,
        lookahead = true, -- Jump forward for better UX
        keymaps = {
          ["af"] = "@function.outer", -- Around function
          ["if"] = "@function.inner", -- Inside function
          ["ac"] = "@class.outer", -- Around class/struct
          ["ic"] = "@class.inner", -- Inside class/struct
          ["aa"] = "@parameter.outer", -- Around args
          ["ia"] = "@parameter.inner", -- Inside args
        },
      },

      -- Navigation: ]f/[f to next/prev function
      move = {
        enable = true,
        set_jumps = true, -- Add to jumplist
        goto_next_start = {
          ["]f"] = "@function.outer", -- Next function
          ["]c"] = "@class.outer", -- Next class
          ["]a"] = "@parameter.inner", -- Next arg
        },
        goto_previous_start = {
          ["[f"] = "@function.outer", -- Prev function
          ["[c"] = "@class.outer", -- Prev class
          ["[a"] = "@parameter.inner", -- Prev arg
        },
      },

      -- Swap: <leader>a to swap params (e.g., in Go/Python functions)
      swap = {
        enable = true,
        swap_next = { ["<leader>a"] = "@parameter.inner" },
        swap_previous = { ["<leader>A"] = "@parameter.inner" },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter-textobjects").setup(opts)
    end,
  },
}
