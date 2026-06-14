return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    local lint = require("lint")
    lint.linters_by_ft = {
      python = { "ruff" },
      javascript = { "eslint_d" },
      typescript = { "eslint_d" },
      dockerfile = { "hadolint" },
      sh = { "shellcheck" },
      bash = { "shellcheck" },
    }
    vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "TextChanged" }, {
      callback = function()
        lint.try_lint()
      end,
    })
  end,
}
