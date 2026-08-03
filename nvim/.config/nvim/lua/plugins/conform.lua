return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  init = function() vim.o.formatexpr = "v:lua.require'conform'.formatexpr()" end,
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      terraform = { "terraform_fmt" },
      javascript = { "prettier" },
      typescript = { "prettier" },
      javascriptreact = { "prettier" },
      typescriptreact = { "prettier" },
      ["*"] = { "trim_whitespace" },
    },
    format_on_save = {
      lsp_format = "fallback",
      timeout_ms = 2000,
    },
  },
}
