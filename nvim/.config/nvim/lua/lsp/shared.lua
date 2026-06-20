local capabilities = require("blink.cmp").get_lsp_capabilities(
  vim.lsp.protocol.make_client_capabilities()
)

vim.lsp.config["*"] = {
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    local bufopts = { buffer = bufnr, noremap = true, silent = true }
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
    vim.keymap.set({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, bufopts)
    vim.keymap.set("n", "<leader>f", function()
      require("conform").format({ async = true, lsp_fallback = true })
    end, bufopts)
    vim.notify(client.name .. " attached", vim.log.levels.DEBUG)
  end,
}
