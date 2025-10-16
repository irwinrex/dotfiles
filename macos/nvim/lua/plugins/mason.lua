return {
  "mason-org/mason.nvim",
  opts = function(_, opts)
    vim.list_extend(opts.ensure_installed, {
      -- Core Language Servers
      "gopls", -- Go
      "basedpyright", -- Python (or "pyright")
      "bash-language-server", -- Shell
      "yaml-language-server", -- YAML
      "dockerfile-language-server", -- Docker
      "terraform-ls", -- Terraform
      "typescript-language-server", -- JS/TS
      "json-lsp", -- JSON
      "lua-language-server", -- Lua

      -- Essential Formatters
      "gofumpt", -- Go
      "ruff", -- Python
      "shfmt", -- Shell
      "prettier", -- Web/YAML/JSON

      -- Essential Linters
      "golangci-lint", -- Go
      "shellcheck", -- Shell
      "yamllint", -- YAML
      "hadolint", -- Docker
      "eslint_d", -- JS/TS

      -- Debuggers
      "delve", -- Go
      "debugpy", -- Python
    })
  end,
}
