return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        terraformls = {
          handlers = {
            ["textDocument/publishDiagnostics"] = function(_, result, ctx)
              if result.diagnostics then
                result.diagnostics = vim.tbl_filter(function(d)
                  return d.message:lower():find("unused") ~= nil
                end, result.diagnostics)
              end
              vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx)
            end,
          },
          settings = {
            terraform = {
              experimentalFeatures = {
                validateOnSave = true,
              },
            },
          },
        },
      },
    },
  },
}
