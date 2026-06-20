vim.lsp.config("terraformls", {
  cmd = { "terraform-ls", "serve" },
  filetypes = { "terraform", "terraform-vars", "hcl" },
  root_dir = vim.fs.root(0, { ".terraform", ".git", ".tf"}) or vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
  handlers = {
    ["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
      if result.diagnostics then
        result.diagnostics = vim.tbl_filter(function(d)
          local msg = d.message:lower()
          return not (
            msg:match("not installed") or
            (msg:match("provider") and msg:match("not found")) or
            msg:match("missing version constraint")
          )
        end, result.diagnostics)
      end
      vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx, config)
    end,
  },
})
vim.lsp.enable("terraformls")
