-- Consolidated conform.nvim formatters
return {
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.python = { "ruff_organize_imports", "ruff_format" }
      opts.formatters_by_ft.go = { "goimports-reviser", "gofumpt" }
      opts.formatters_by_ft.terraform = { "terraform_fmt" }
      opts.formatters_by_ft.tf = { "terraform_fmt" }
      opts.formatters_by_ft.hcl = { "terraform_fmt" }
      opts.formatters_by_ft.sh = { "shfmt" }
      opts.formatters_by_ft.bash = { "shfmt" }
      opts.formatters_by_ft.yaml = { "prettier", "yamlfix" }
      opts.formatters_by_ft["yaml.ansible"] = { "prettier", "yamlfix" }
      opts.formatters_by_ft.dockerfile = { "hadolint" } -- hadolint can format some aspects, but mainly linters. 
      -- Use 'shfmt' for Dockerfile if you use it in scripts, but typically Docker doesn't have a direct formatter.
      -- Many use prettier for Dockerfiles too.
      opts.formatters_by_ft.dockerfile = { "prettier" } 
      opts.formatters_by_ft.html = { "prettier" }
      opts.formatters_by_ft.css = { "prettier" }
      opts.formatters_by_ft.javascript = { "prettier" }
      opts.formatters_by_ft.typescript = { "prettier" }
      opts.formatters_by_ft.javascriptreact = { "prettier" }
      opts.formatters_by_ft.typescriptreact = { "prettier" }
      opts.formatters_by_ft.json = { "prettier" }
      opts.formatters_by_ft.markdown = { "prettier", "markdown-toc" }
      opts.formatters_by_ft["markdown.mdx"] = { "prettier", "markdown-toc" }
      opts.formatters_by_ft.rust = { "rustfmt" }
    end,
  },
}

