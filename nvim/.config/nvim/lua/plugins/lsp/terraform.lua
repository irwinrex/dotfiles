return {
  {
    "neovim/nvim-lspconfig",
    ft = { "terraform", "terraform-vars" },
    opts = {
      servers = {
        terraformls = {
          on_init = function(client)
            client.server_capabilities.semanticTokensProvider = nil
          end,
          handlers = {
            ["textDocument/publishDiagnostics"] = function(_, result, ctx)
              if result.diagnostics then
                result.diagnostics = vim.tbl_filter(function(d)
                  local msg = d.message:lower()
                  return not (
                    msg:find("not installed")
                    or msg:find("provider") and msg:find("not found")
                    or msg:find("missing version constraint")
                  )
                end, result.diagnostics)
              end
              vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx)
            end,
          },
          settings = {
            terraform = {
              validateOnSave = true,
            },
          },
        },
      },
    },
  },
}
