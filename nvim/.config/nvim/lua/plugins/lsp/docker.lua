-- Dockerfile only (docker-compose goes to yaml.lua)
return {
  {
    "nvim-lua/plenary.nvim",
    lazy = true,
    init = function()
      vim.filetype.add({
        pattern = {
          ["Dockerfile%..*"] = "dockerfile",
          ["Dockerfile"] = "dockerfile",
          [".*[Dd]ockerfile.*"] = "dockerfile",
        },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    ft = "dockerfile",
    config = function()
      local lspconfig = require("lspconfig")
      local util = require("lspconfig.util")

      lspconfig.dockerls.setup({
        root_dir = function(fname)
          return util.root_pattern("Dockerfile", ".git")(fname) or util.path.dirname(fname)
        end,
        on_attach = function(client, _)
          client.server_capabilities.semanticTokensProvider = nil
        end,
        settings = {
          hadolint = {
            ignore = { "DL3008" },
          },
        },
      })
    end,
  },
}