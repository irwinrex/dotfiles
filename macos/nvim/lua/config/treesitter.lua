return {
  ensure_installed = {
    -- Go Development
    "go",
    "gomod",
    "gowork",
    "gosum",
    "templ", -- Go templating language

    -- Python Development
    "python",

    -- Web Development
    "javascript",
    "typescript",
    "tsx",
    "html",
    "css",
    "scss",
    "vue",
    "svelte",
    "astro",

    -- DevOps & Infrastructure
    "terraform",
    "hcl",
    "dockerfile",
    "yaml",
    "json",
    "jsonc", -- JSON with comments
    "toml",
    "ini",

    -- Shell & System
    "bash",
    "fish",
    "zsh",
    "powershell",

    -- Configuration Files
    "gitignore",
    "gitattributes",
    "gitcommit",
    "git_config",
    "git_rebase",
    "ssh_config",
    "hosts",

    -- Documentation & Markup
    "markdown",
    "markdown_inline",
    "rst",
    "latex",
    "bibtex",

    -- Query Languages
    "sql",
    "graphql",
    "sparql",

    -- Data Formats
    "xml",
    "csv",
    "jq", -- jq query language

    -- Programming Languages
    "c",
    "cpp",
    "rust",
    "zig",
    "java",
    "kotlin",
    "scala",
    "php",
    "ruby",
    "perl",
    "r",

    -- Functional Languages
    "haskell",
    "ocaml",
    "erlang",
    "elixir",

    -- JVM Languages
    "clojure",
    "groovy", -- For Jenkins

    -- Mobile Development
    "swift",
    "dart", -- Flutter

    -- Systems Languages
    "nix",
    "just", -- Justfile
    "make",
    "cmake",
    "meson",

    -- Base Languages & Core
    "lua",
    "luadoc",
    "luap", -- Lua patterns
    "vim",
    "vimdoc",
    "query", -- Tree-sitter queries
    "regex",

    -- Protocols & APIs
    "http",
    "proto", -- Protocol Buffers
    "thrift",

    -- Specialized
    "dot", -- Graphviz
    "mermaid", -- Diagrams
    "plantuml", -- UML diagrams
    "dbml", -- Database markup
    "prisma", -- Prisma schema

    -- Package Managers
    "requirements", -- pip requirements.txt
    "pip_requirements",

    -- Cloud & Containers
    "helm", -- Kubernetes Helm
    "kusto", -- Azure Data Explorer
    "promql", -- Prometheus queries

    -- Comment parsing for better highlighting
    "comment",

    -- Diff support
    "diff",

    -- Log files
    "log",
  },

  -- Enhanced highlighting
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
    -- Disable for large files to improve performance
    disable = function(lang, buf)
      local max_filesize = 100 * 1024 -- 100 KB
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then
        return true
      end
    end,
  },

  -- Enhanced indentation
  indent = {
    enable = true,
    -- Disable for specific languages where it causes issues
    disable = { "python", "yaml" },
  },

  -- Incremental selection with enhanced keymaps
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<C-space>",
      node_incremental = "<C-space>",
      scope_incremental = "<C-s>",
      node_decremental = "<M-space>",
    },
  },

  -- Text objects for better navigation
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj
      keymaps = {
        -- Functions
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        -- Classes
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        -- Conditionals
        ["ai"] = "@conditional.outer",
        ["ii"] = "@conditional.inner",
        -- Loops
        ["al"] = "@loop.outer",
        ["il"] = "@loop.inner",
        -- Parameters/arguments
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",
        -- Comments
        ["aC"] = "@comment.outer",
        ["iC"] = "@comment.inner",
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]m"] = "@function.outer",
        ["]]"] = "@class.outer",
        ["]c"] = "@conditional.outer",
        ["]l"] = "@loop.outer",
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]["] = "@class.outer",
        ["]C"] = "@conditional.outer",
        ["]L"] = "@loop.outer",
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[["] = "@class.outer",
        ["[c"] = "@conditional.outer",
        ["[l"] = "@loop.outer",
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[]"] = "@class.outer",
        ["[C"] = "@conditional.outer",
        ["[L"] = "@loop.outer",
      },
    },
  },

  -- Folding based on treesitter
  fold = {
    enable = true,
    disable = {}, -- list of languages to disable folding for
  },

  -- Auto-install missing parsers when entering buffer
  auto_install = true,

  -- Sync install (only applied to `ensure_installed`)
  sync_install = false,

  -- Ignore install errors
  ignore_install = {},

  -- Enhanced query predicates
  query_linter = {
    enable = true,
    use_virtual_text = true,
    lint_events = { "BufWrite", "CursorHold" },
  },

  -- Playground for testing queries (if nvim-treesitter-playground is installed)
  playground = {
    enable = true,
    disable = {},
    updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
    persist_queries = false, -- Whether the query persists across vim sessions
    keybindings = {
      toggle_query_editor = "o",
      toggle_hl_groups = "i",
      toggle_injected_languages = "t",
      toggle_anonymous_nodes = "a",
      toggle_language_display = "I",
      focus_language = "f",
      unfocus_language = "F",
      update = "R",
      goto_node = "<cr>",
      show_help = "?",
    },
  },

  -- Rainbow parentheses (if nvim-ts-rainbow is installed)
  rainbow = {
    enable = true,
    -- list of languages you want to disable the plugin for
    disable = {},
    -- Which query to use for finding delimiters
    query = "rainbow-parens",
    -- Highlight the entire buffer all at once
    strategy = require("ts-rainbow").strategy.global,
    -- Do not enable for files with more than n lines
    max_file_lines = 3000,
  },

  -- Context commentstring (for better commenting)
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  },

  -- Autopairs integration
  autopairs = {
    enable = true,
  },

  -- Enhanced matching with % key
  matchup = {
    enable = true,
    disable = {}, -- list of languages to disable
    -- Enable timeout for better performance
    disable_virtual_text = false,
    include_match_words = true,
  },
}
