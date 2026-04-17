-- LazyVim LSP configuration with all language servers
return {
  { "b0o/SchemaStore.nvim", lazy = true },

  {
    "neovim/nvim-lspconfig",
    opts = {
      -- Disable semantic tokens globally to prioritize Tree-sitter highlights for performance
      on_attach = function(client, _)
        client.server_capabilities.semanticTokensProvider = nil
      end,
      servers = {
        -- LSP Servers (will be auto-installed via mason-lspconfig)
        gopls = {},
        rust_analyzer = {},
        ts_ls = {},
        basedpyright = {},
        pyright = {},
        ruff = {},
        clangd = {},
        html = {},
        cssls = {},
        jsonls = {},
        yamlls = {},
        marksman = {},
        bashls = {},
        dockerls = {},
        docker_compose_language_service = {},
        terraformls = {},
        ansiblels = {},
        quick_lint_js = {},
        alloy = {},
        groovy_ls = {},
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = { globals = { "vim" } },
              workspace = { checkThirdParty = false },
              telemetry = { enable = false },
            },
          },
        },
      },
      setup = {},
    },
  },
}
