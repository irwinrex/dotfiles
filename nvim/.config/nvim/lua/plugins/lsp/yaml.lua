-- YAML / Ansible LSP and tooling
return {
  {
    "nvim-lua/plenary.nvim",
    lazy = true,
    init = function()
      vim.filetype.add({
        pattern = {
          [".*/tasks/.*%.ya?ml"] = "yaml.ansible",
          [".*/playbooks/.*%.ya?ml"] = "yaml.ansible",
          [".*/handlers/.*%.ya?ml"] = "yaml.ansible",
          [".*/roles/.*%.ya?ml"] = "yaml.ansible",
        },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        yamlls = {
          -- Fix: Better root detection for monorepos and helm/k8s projects
          root_dir = function(fname)
            local util = require("lspconfig.util")
            return util.root_pattern(".git", ".yamllint", "Chart.yaml")(fname) or util.path.dirname(fname)
          end,
          on_attach = function(client, bufnr)
            -- Disable semantic tokens to prioritize Tree-sitter highlights
            client.server_capabilities.semanticTokensProvider = nil
            if vim.bo[bufnr].filetype == "yaml.ansible" then
              client.stop()
            end
          end,
          on_new_config = function(new_config)
            new_config.settings = new_config.settings or {}
            new_config.settings.yaml = new_config.settings.yaml or {}
            new_config.settings.yaml.schemas = vim.tbl_deep_extend(
              "force",
              new_config.settings.yaml.schemas or {},
              require("schemastore").yaml.schemas()
            )
          end,
          settings = {
            redhat = { telemetry = { enabled = false } },
            yaml = {
              keyOrdering = false,
              format = { enable = true },
              validate = true,
              schemaStore = { enable = false, url = "" },
              -- Reduced noise by ignoring specific warnings
              customTags = { "!reference", "!vault" }, -- GitLab/Ansible tags
            },
          },
        },
        ansiblels = {},
      },
    },
  },
}
