-- Treesitter configuration
return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = "VeryLazy",
    opts = {
      ensure_installed = {
        -- Core
        "lua",
        "vim",
        "vimdoc",
        "query",
        -- Web
        "html",
        "css",
        "javascript",
        "typescript",
        "tsx",
        "json",
        "jsonc",
        -- Systems
        "bash",
        "c",
        "cpp",
        "go",
        "rust",
        "python",
        "ruby",
        -- DevOps
        "yaml",
        "toml",
        "dockerfile",
        "hcl",
        "groovy",
        -- Data
        "sql",
        "graphql",
        -- Docs
        "markdown",
        "markdown_inline",
        "latex",
      },
      sync_install = false,
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = "nvim-treesitter/nvim-treesitter",
  },
}
