-- plugins/language/terraform.lua

return {
  ---------------------------------------------------------------------------
  -- Mason registry (ensure Terraform tools exist)
  ---------------------------------------------------------------------------
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        "terraformls",
        "tflint",
      },
    },
  },

  ---------------------------------------------------------------------------
  -- Formatting via conform.nvim (terraform fmt)
  ---------------------------------------------------------------------------
  {
    "stevearc/conform.nvim",
    ft = { "terraform", "tf", "hcl", "terraform-vars" },
    opts = {
      formatters_by_ft = {
        terraform = { "terraform_fmt" },
        tf = { "terraform_fmt" },
        hcl = { "packer_fmt" }, -- packer .hcl
        ["terraform-vars"] = { "terraform_fmt" },
      },
      -- No format_on_save here — LazyVim controls it globally
    },
  },

  ---------------------------------------------------------------------------
  -- Linting: terraform_validate (schema + HCL sanity)
  ---------------------------------------------------------------------------
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    ft = { "terraform", "tf", "hcl" },
    opts = {
      linters_by_ft = {
        terraform = { "terraform_validate" },
        tf = { "terraform_validate" },
        hcl = { "terraform_validate" },
      },
    },
  },

  ---------------------------------------------------------------------------
  -- Telescope integration: Terraform documentation browser
  ---------------------------------------------------------------------------
  {
    "ANGkeith/telescope-terraform-doc.nvim",
    ft = { "terraform", "hcl", "tf" },
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("telescope").load_extension("terraform_doc")
    end,
  },

  ---------------------------------------------------------------------------
  -- Telescope integration: Terraform file / state browser
  ---------------------------------------------------------------------------
  {
    "cappyzawa/telescope-terraform.nvim",
    ft = { "terraform", "hcl", "tf" },
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("telescope").load_extension("terraform")
    end,
  },
}
