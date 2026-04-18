-- Dockerfile filetype detection
return {
  {
    "nvim-lua/plenary.nvim",
    lazy = true,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        dockerls = {
          -- Fix: Better root detection for Docker projects
          root_dir = function(fname)
            local util = require("lspconfig.util")
            return util.root_pattern("Dockerfile", ".git")(fname) or util.path.dirname(fname)
          end,
          on_attach = function(client, _)
            client.server_capabilities.semanticTokensProvider = nil
          end,
        },
        docker_compose_language_service = {
          -- Fix: Better root detection for Compose projects
          root_dir = function(fname)
            local util = require("lspconfig.util")
            return util.root_pattern("docker-compose.yaml", "docker-compose.yml", ".git")(fname)
              or util.path.dirname(fname)
          end,
          on_attach = function(client, _)
            client.server_capabilities.semanticTokensProvider = nil
          end,
        },
        hadolint = {
          settings = {
            hadolint = {
              ignore = { "DL3008" }, -- Pin versions in apt-get install (often noisy)
            },
          },
        },
      },
    },
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
}
