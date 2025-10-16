return {
  ensure_installed = {
    -- Go
    "gopls",
    "delve",
    "goimports",
    "gofumpt",
    "gomodifytags",
    "impl",
    -- Python
    "pyright",
    "debugpy",
    "ruff",
    "ruff-lsp",
    "black",
    "isort",
    -- Terraform
    "terraform-ls",
    "tflint",
    -- Docker
    "dockerfile-language-server",
    "docker-compose-language-service",
    "hadolint",
    -- Other
    "bash-language-server",
    "json-lsp",
    "yaml-language-server",
    "prettier",
  },
  automatic_installation = true,
}
