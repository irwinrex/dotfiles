local capabilities = require("blink.cmp").get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities())

vim.diagnostic.config({
  severity_sort = true,
  update_in_insert = false,
  underline = true,
  signs = true,
  virtual_text = false,
  float = {
    border = "rounded",
    source = true,
  },
})

vim.lsp.config("*", {
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    local function bufopts(desc) return { buffer = bufnr, silent = true, desc = desc } end

    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts("Go to declaration"))
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts("Go to definition"))
    vim.keymap.set("n", "<leader>lr", ":LspRestart<CR>", bufopts("Restart LSP server"))
    vim.keymap.set("n", "<leader>f", function()
      if vim.bo[bufnr].filetype == "go" then
        vim.lsp.buf.format({ bufnr = bufnr, name = "gopls", async = true })
      else
        require("conform").format({ async = true, lsp_format = "fallback" })
      end
    end, bufopts("Format buffer"))

    vim.notify(client.name .. " attached", vim.log.levels.DEBUG)
  end,
})
