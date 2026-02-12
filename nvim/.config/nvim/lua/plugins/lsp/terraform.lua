-- ~/.config/nvim/lua/plugins/language/terraform.lua

return {
  ---------------------------------------------------------------------------
  -- 1. THE COMPLETION ENGINE (Blink.cmp)
  ---------------------------------------------------------------------------
  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      opts.sources.default = { "lsp", "path", "snippets", "buffer" }
    end,
  },

  ---------------------------------------------------------------------------
  -- 2. LSP CONFIGURATION
  ---------------------------------------------------------------------------
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        terraformls = {
          -- 2026 practice: Let LazyVim handle the root_dir unless you have unique needs
          root_dir = require("lspconfig.util").root_pattern("terragrunt.hcl", ".terraform", ".git", "main.tf"),
          settings = {
            terraform = {
              experimentalFeatures = {
                prefillRequiredFields = true,
              },
            },
          },
        },
      },
      -- FIXED: Use 'setup' table to disable formatting without overriding the whole config
      setup = {
        terraformls = function(_, opts)
          LazyVim.lsp.on_attach(function(client, _)
            if client.name == "terraformls" then
              -- Disable LSP formatting to let conform.nvim handle it exclusively
              client.server_capabilities.documentFormattingProvider = false
              client.server_capabilities.documentRangeFormattingProvider = false
            end
          end)
        end,
      },
    },
  },

  ---------------------------------------------------------------------------
  -- 3. TOOL INSTALLER (Mason)
  ---------------------------------------------------------------------------
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "terraform-ls",
        "tflint",
      })
    end,
  },

  ---------------------------------------------------------------------------
  -- 4. FORMATTING (Conform)
  ---------------------------------------------------------------------------
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        terraform = { "terraform_fmt" },
        tf = { "terraform_fmt" },
        hcl = { "terraform_fmt" },
      },
    },
  },

  ---------------------------------------------------------------------------
  -- 5. LINTING (Nvim-lint)
  ---------------------------------------------------------------------------
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        terraform = { "tflint" },
        tf = { "tflint" },
      },
    },
  },
}
