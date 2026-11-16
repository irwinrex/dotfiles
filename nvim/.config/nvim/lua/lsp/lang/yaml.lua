vim.lsp.config("yamlls", {
  settings = {
    redhat = { telemetry = { enabled = false } },
    yaml = {
      format = { enable = true },
      validate = true,
      hover = true,
      completion = true,
      schemaStore = {
        enable = true,
        url = "https://www.schemastore.org/api/json/catalog.json",
      },
      schemaDownload = { enable = true },
      kubernetesCRDStore = {
        enable = true,
        url = "https://raw.githubusercontent.com/datreeio/CRDs-catalog/main",
      },
      -- Adjust to your cluster version if needed.
      kubernetesVersion = "v1.34.1",
      -- Kubernetes resources are auto-detected by apiVersion/kind.
      -- Add explicit glob mappings here for files without a GVK (e.g. Kustomize).
      schemas = {},
    },
  },
})
vim.lsp.enable("yamlls")