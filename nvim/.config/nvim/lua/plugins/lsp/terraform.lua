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
    init = function()
      vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
        group = vim.api.nvim_create_augroup("terraform_autosave", { clear = true }),
        pattern = { "*.tf", "*.tfvars" },
        callback = function()
          if vim.bo.modified and vim.bo.modifiable and vim.bo.buftype == "" then
            vim.cmd("silent! write")
          end
        end,
      })
    end,
  },
}
