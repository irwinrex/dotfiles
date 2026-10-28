local capabilities = require("blink.cmp").get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities())

vim.diagnostic.config({
  severity_sort = true,
  update_in_insert = false,
  underline = true,
  signs = true,
  virtual_text = false,
  jump = {
    on_jump = function(_, bufnr)
      vim.diagnostic.open_float({ bufnr = bufnr })
    end,
  },
  float = {
    border = "rounded",
    source = true,
    header = "Diagnostics",
    suffix = "",
    focusable = true,
  },
})

vim.lsp.config("*", {
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    local function bufopts(desc) return { buffer = bufnr, silent = true, desc = desc } end

    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts("Go to declaration"))
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts("Go to definition"))
    -- Stop the clients attached to this buffer, then re-fire FileType so
    -- vim.lsp.enable()/rustaceanvim spawn a fresh instance. Avoids the
    -- nonexistent :LspRestart command from the lspconfig era.
    vim.keymap.set("n", "<leader>lr", function()
      local clients = vim.lsp.get_clients({ bufnr = bufnr })
      if #clients == 0 then return end
      local names = vim.tbl_map(function(c) return c.name end, clients)
      vim.lsp.stop_client(clients, true)
      vim.defer_fn(function()
        pcall(vim.api.nvim_exec_autocmds, "FileType", { buffer = bufnr })
      end, 300)
      vim.notify("Restarting " .. table.concat(names, ", "), vim.log.levels.INFO)
    end, bufopts("Restart LSP server"))
    vim.keymap.set("n", "<leader>f", function()
      if vim.bo[bufnr].filetype == "go" then
        vim.lsp.buf.format({ bufnr = bufnr, name = "gopls", async = true })
      elseif vim.bo[bufnr].filetype == "rust" then
        vim.lsp.buf.format({ bufnr = bufnr, name = "rust-analyzer", async = true })
      else
        require("conform").format({ async = true, lsp_format = "fallback" })
      end
    end, bufopts("Format buffer"))
  end,
})
