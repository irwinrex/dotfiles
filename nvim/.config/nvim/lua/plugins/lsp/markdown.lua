-- Markdown LSP and tooling
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        marksman = {
          settings = {
            marksman = {
              urlStyle = "markdown",
            },
          },
        },
      },
    },
  },
  -- Optionally, disable the markdownlint-cli2 warning/errors as well
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = function(_, opts)
      opts.linters_by_ft = opts.linters_by_ft or {}
      opts.linters_by_ft.markdown = {}
      opts.linters_by_ft["markdown.mdx"] = {}
    end,
  },
}