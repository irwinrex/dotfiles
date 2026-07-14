return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  init = function()
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      go = { "gofumpt", "goimports" },
      terraform = { "terraform_fmt" },
      javascript = { "prettier" },
      typescript = { "prettier" },
      javascriptreact = { "prettier" },
      typescriptreact = { "prettier" },
      ["*"] = { "trim_whitespace" },
    },
    format_on_save = {
      lsp_fallback = true,
      timeout_ms = 500,
    },
  },
}
