return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  config = function()
    require("conform").setup({
      formatters_by_ft = {
        lua = { "stylua" },
        go = { "gofmt", "goimports" },
        python = { "ruff_format", "black" },
        rust = { "rustfmt" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        dockerfile = { "hadolint" },
        c = { "clang_format" },
        cpp = { "clang_format" },
        terraform = { "terraform_fmt" },
        ["terraform-vars"] = { "terraform_fmt" },
      },
      formatters = {
        terraform_fmt = {
          format = function(_, ctx, lines, callback)
            local input = table.concat(lines, "\n")
            if vim.bo[ctx.buf].eol then
              input = input .. "\n"
            end
            vim.system(
              { "terraform", "fmt", "-no-color", "-" },
              { stdin = input, text = true },
              function(result)
                if result.code == 0 then
                  local output = vim.split(result.stdout, "\r?\n")
                  if vim.bo[ctx.buf].eol and output[#output] == "" then
                    table.remove(output)
                  end
                  if #output == 0 then
                    table.insert(output, "")
                  end
                  callback(nil, output)
                else
                  local msg = result.stderr:match("\n\n(.*)\n\n")
                    or result.stderr:match("[^\n]+")
                    or "unknown error"
                  vim.notify("terraform_fmt: " .. msg, vim.log.levels.ERROR)
                  callback(nil, lines)
                end
              end
            )
          end,
        },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
    })
  end,
}