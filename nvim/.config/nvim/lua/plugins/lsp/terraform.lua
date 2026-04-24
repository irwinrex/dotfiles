return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        terraformls = {
          root_dir = function(fname)
            local util = require("lspconfig.util")
            return util.root_pattern(".terraform", ".terraform.lock.hcl", "terragrunt.hcl", "main.tf", ".git")(fname)
              or vim.fs.dirname(fname)
          end,
          settings = {
            ["terraform-ls"] = {
              ignoreSingleFileWarning = true,
            },
          },
          on_attach = function(client, bufnr)
            client.server_capabilities.semanticTokensProvider = nil
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = bufnr,
              callback = function()
                local fname = vim.api.nvim_buf_get_name(bufnr)
                vim.fn.system({ "terraform", "fmt", fname })
                vim.cmd("silent! edit!")
              end,
            })
          end,
        },
      },
    },
  },
}
