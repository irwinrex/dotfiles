return {
  ensure_installed = {
    -- Core Languages (from installation scripts)
    -- Go Development
    "go",
    "gomod",
    "gowork",
    "gosum",
    "templ", -- Go templating

    -- Python Development
    "python",

    -- Web Development (TypeScript/JavaScript stack)
    "javascript",
    "typescript",
    "tsx",
    "html",
    "css",
    "scss",
    "json",
    "jsonc", -- JSON with comments

    -- DevOps & Infrastructure (core tools installed)
    "dockerfile",
    "yaml",
    "terraform",
    "hcl",
    "toml",

    -- Shell & System (bash-language-server installed)
    "bash",
    "zsh",
    "fish",

    -- Configuration & Git
    "gitignore",
    "gitattributes",
    "gitcommit",
    "git_config",
    "git_rebase",

    -- Documentation (marksman installed)
    "markdown",
    "markdown_inline",

    -- Query & Data
    "sql", -- sql-language-server installed
    "graphql",

    -- Base Languages & Core (lua-language-server installed)
    "lua",
    "luadoc",
    "vim",
    "vimdoc",
    "query", -- Tree-sitter queries
    "regex",

    -- Additional useful formats
    "xml",
    "ini",
    "csv",

    -- Development essentials
    "comment",
    "diff",

    -- Optional: Popular languages (lightweight additions)
    "rust", -- For tooling (stylua, etc.)
    "c",
    "cpp",
    "java",
    "php",
    "ruby",

    -- DevOps extras (if using Kubernetes)
    "helm",
    "proto", -- Protocol Buffers

    -- Log parsing
    "log",
  },

  -- Performance-optimized highlighting
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
    -- Disable for large files and less common languages
    disable = function(lang, buf)
      local max_filesize = 200 * 1024 -- 200 KB (increased from 100KB)
      local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then
        return true
      end

      -- Disable for less performance-critical languages in large projects
      local disable_for_large = { "log", "csv", "ini" }
      if vim.tbl_contains(disable_for_large, lang) and stats and stats.size > 50 * 1024 then
        return true
      end
    end,
  },

  -- Selective indentation (avoid problematic languages)
  indent = {
    enable = true,
    disable = { "python", "yaml", "markdown" }, -- These often have indent issues
  },

  -- Essential incremental selection
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<C-space>",
      node_incremental = "<C-space>",
      scope_incremental = "<C-s>",
      node_decremental = "<M-space>",
    },
  },

  -- Core text objects (focus on most used)
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        -- Functions (most important)
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        -- Classes
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        -- Parameters (very useful for Go/Python)
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",
        -- Comments
        ["aC"] = "@comment.outer",
        ["iC"] = "@comment.inner",
      },
    },
    move = {
      enable = true,
      set_jumps = true,
      goto_next_start = {
        ["]m"] = "@function.outer",
        ["]]"] = "@class.outer",
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]["] = "@class.outer",
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[["] = "@class.outer",
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[]"] = "@class.outer",
      },
    },
  },

  -- Essential folding
  fold = {
    enable = true,
    disable = { "vim" }, -- Vim files can have folding issues
  },

  -- Auto-install for development workflow
  auto_install = true,
  sync_install = false,
  ignore_install = {},

  -- Core features only (remove optional plugin dependencies)
  -- Removed: playground, rainbow, context_commentstring, autopairs, matchup
  -- These should be configured separately if the respective plugins are installed
}
