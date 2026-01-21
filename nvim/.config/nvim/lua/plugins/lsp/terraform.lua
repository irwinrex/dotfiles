local util = require("lspconfig.util")

local capabilities = require("cmp_nvim_lsp").default_capabilities()

return {

  -- LSP
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        terraformls = {
          capabilities = capabilities,

          root_dir = util.root_pattern("terragrunt.hcl", ".terraform", ".git"),

          on_attach = function(client)
            -- Formatting is owned by conform.nvim
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
          end,

          settings = {
            terraform = {
              ignoreSingleFileWarning = true,
            },
          },

          single_file_support = false, -- avoids random popups outside projects
        },
      },
    },
  },

  -- Tooling install (single source of truth)
  {
    "mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "terraform-ls",
        "tflint",
      })
    end,
  },

  {
    "mason-lspconfig.nvim",
    opts = {
      ensure_installed = { "terraformls" },
      automatic_installation = true,
    },
  },

  -- Formatting (quiet, deterministic)
  {
    "conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        terraform = { "terraform_fmt" },
        tf = { "terraform_fmt" },
        hcl = { "terraform_fmt" },
      },
    },
  },

  -- Linting (manual trigger recommended)
  {
    "nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        terraform = { "tflint" },
        tf = { "tflint" },
      },
    },
  },
}
