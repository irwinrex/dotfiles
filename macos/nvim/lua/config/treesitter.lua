return {
  ensure_installed = {
    -- Go
    "go",
    "gomod",
    "gowork",
    "gosum",

    -- Python
    "python",

    -- Terraform & Docker
    "terraform",
    "hcl",
    "dockerfile",

    -- Supporting languages
    "bash",
    "json",
    "yaml",
    "toml",

    -- Base languages
    "lua",
    "vim",
    "markdown",
    "markdown_inline",
  },

  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },

  indent = {
    enable = true,
  },

  incremental_selection = {
    enable = true,
  },
}
