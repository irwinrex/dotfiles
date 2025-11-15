-- plugins/language/terraform.lua

return {
  -- Ensure Terraform LSP is always installed
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = { "terraformls", "tflint" },
    },
  },

  -- Use conform.nvim for formatting
  {
    "stevearc/conform.nvim",
    ft = { "terraform", "tf", "hcl", "terraform-vars" },
    opts = {
      formatters_by_ft = {
        terraform = { "terraform_fmt" },
        tf = { "terraform_fmt" },
        hcl = { "packer_fmt" },
        ["terraform-vars"] = { "terraform_fmt" },
      },
      -- REMOVE format_on_save, let LazyVim handle it!
    },
  },

  -- nvim-lint for linting
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    ft = { "terraform", "tf" },
    opts = {
      linters_by_ft = {
        terraform = { "terraform_validate" },
        tf = { "terraform_validate" },
      },
    },
  },

  -- Telescope extension: terraform-doc
  {
    "ANGkeith/telescope-terraform-doc.nvim",
    ft = { "terraform", "hcl" },
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("telescope").load_extension("terraform_doc")
    end,
  },

  -- Telescope extension: terraform state browsing
  {
    "cappyzawa/telescope-terraform.nvim",
    ft = { "terraform", "hcl" },
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("telescope").load_extension("terraform")
    end,
  },
}
