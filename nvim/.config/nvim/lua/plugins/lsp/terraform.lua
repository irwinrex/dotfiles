-- plugins/lsp/terraform.lua
local util = require("lspconfig.util")

-- Correct capabilities setup - using cmp_nvim_lsp for proper integration
local capabilities = require("cmp_nvim_lsp").default_capabilities()

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "terraform", "hcl" })
      end
    end,
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "hrsh7th/nvim-cmp" },
      { "hrsh7th/cmp-nvim-lsp" },
    },
    opts = {
      servers = {
        terraformls = {
          capabilities = capabilities,
          root_dir = util.root_pattern(
            ".terraform",
            ".git",
            "terraform.rc",
            "main.tf",
            "variables.tf",
            "terragrunt.hcl"
          ),
          on_attach = function(client, bufnr)
            -- Disable LSP formatting to avoid conflicts with conform.nvim
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false

            -- Setup keymaps for Terraform commands
            local map = function(mode, lhs, rhs, desc)
              vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
            end

            map("n", "<leader>cV", function()
              vim.lsp.buf.execute_command({
                command = "terraform-ls.validate",
                arguments = { vim.api.nvim_buf_get_name(bufnr) },
              })
            end, "LSP: Validate File")
          end,
          settings = {
            terraform = {
              ignoreSingleFileWarning = true,
            },
            files = {
              exclude = {
                "**/.terraform/**",
                "**/.tflint.d/**",
              },
            },
            ["terraform-ls"] = { -- Fixed: Use string key with hyphen
              maxConcurrentRequests = 5,
            },
          },
          single_file_support = true,
        },
      },
    },
  },

  {
    "mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "terraform-ls", "tflint" })
    end,
  },

  {
    "mason-lspconfig.nvim",
    opts = {
      ensure_installed = { "terraformls" },
      automatic_installation = true,
    },
  },

  {
    "conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        terraform = { "terraform_fmt" },
        tf = { "terraform_fmt" },
        ["terraform-vars"] = { "terraform_fmt" },
        hcl = { "terraform_fmt" },
      },
    },
  },

  {
    "nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        terraform = { "tflint" },
        tf = { "tflint" },
        hcl = { "tflint" },
      },
    },
  },
}
