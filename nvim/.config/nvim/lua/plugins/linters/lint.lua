-- Linting configuration
return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      linters_by_ft = {
        yaml = { "yamllint", "actionlint" },
        ["yaml.ansible"] = { "ansible-lint" },
        dockerfile = { "hadolint" },
        ["docker-compose"] = { "hadolint" }, -- Can lint compose as well sometimes
        json = { "jsonlint" },
        terraform = { "tflint" },
        tf = { "tflint" },
      },
    },
    config = function(_, opts)
      local lint = require("lint")
      lint.linters_by_ft = vim.tbl_deep_extend("force", lint.linters_by_ft or {}, opts.linters_by_ft)

      -- Suppress tflint module-related noise
      lint.linters.tflint = vim.tbl_deep_extend("force", lint.linters.tflint or {}, {
        args = {
          "--disable-rule=terraform_required_providers",
          "--disable-rule=terraform_required_version",
          "--disable-rule=terraform_module_pinned_source",
        },
      })

      local aug = vim.api.nvim_create_augroup("DevOpsLint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
        group = aug,
        callback = function(ev)
          lint.try_lint()
          local lines = vim.api.nvim_buf_get_lines(ev.buf, 0, 15, false)
          for _, line in ipairs(lines) do
            if line:match("^apiVersion:") then
              lint.try_lint("kube-linter")
              break
            end
          end
        end,
      })
    end,
  },
}
