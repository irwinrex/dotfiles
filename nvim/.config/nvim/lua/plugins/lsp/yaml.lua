-- YAML / Ansible / Kubernetes LSP and tooling
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
    ft = { "yaml", "yaml.ansible" },
    config = function()
      local lspconfig = require("lspconfig")
      local util = require("lspconfig.util")

      -- YAML with Kubernetes schemas + Ansible support
      lspconfig.yamlls.setup({
        root_dir = function(fname)
          return util.root_pattern(
            ".git",
            ".k8s.yaml",
            "Chart.yaml",
            "kustomization.yaml",
            "terragrunt.hcl"
          )(fname) or util.path.dirname(fname)
        end,
        on_attach = function(client, bufnr)
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
            customTags = { "!reference", "!vault", "!include" },
            schemaStore = { enable = true },
            schemaStoreUrls = {
              -- Kubernetes
              "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.29.0-standalone-strict/deployment-v1.29.0.json",
              "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.29.0-standalone-strict/service-v1.29.0.json",
              "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.29.0-standalone-strict/configmap-v1.29.0.json",
              "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.29.0-standalone-strict/ingress-v1.json",
              "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.29.0-standalone-strict/secret-v1.json",
              "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.29.0-standalone-strict/pod-v1.29.0.json",
              -- Docker Compose
              "https://raw.githubusercontent.com/compose-spec/compose-schema/master/schema/compose-spec.json",
            },
          },
        },
      })

      -- Docker Compose language server
      lspconfig.docker_compose_language_service.setup({
        root_dir = function(fname)
          return util.root_pattern(
            "docker-compose.yaml",
            "docker-compose.yml",
            "compose.yaml",
            "compose.yml",
            ".git"
          )(fname) or util.path.dirname(fname)
        end,
        on_attach = function(client, _)
          client.server_capabilities.semanticTokensProvider = nil
        end,
      })

      -- Ansible language server
      lspconfig.ansiblels.setup({
        on_attach = function(client, _)
          client.server_capabilities.semanticTokensProvider = nil
        end,
        settings = {
          ansible = {
            ansible = {
              path = "ansible-lint",
            },
          },
        },
      })
    end,
  },
}