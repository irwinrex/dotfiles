return {
  -- 1. Custom filetype detection for Jenkinsfiles
  {
    "nvim-treesitter/nvim-treesitter", -- Hook into a core plugin to ensure this runs early
    init = function()
      -- Associate Jenkinsfile patterns with the 'groovy' filetype
      vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
        pattern = { "Jenkinsfile", "Jenkinsfile.*", ".*%.jenkinsfile" },
        desc = "Set Jenkinsfile filetype to groovy",
        command = "set filetype=groovy",
      })
    end,
  },
  -- 2. LSP server configurations
  {
    "neovim/nvim-lspconfig",
    dependencies = { "b0o/schemastore.nvim" },
    opts = function(_, opts)
      opts.servers = vim.tbl_deep_extend("force", opts.servers or {}, {
        -- Configure YAML language server with schemas from schemastore
        yamlls = {
          settings = {
            yaml = {
              schemas = require("schemastore").yaml.schemas(),
            },
          },
        },
        -- For dockerls and groovyls, we accept LazyVim's sensible defaults
        dockerls = {},
        groovyls = {},
      })
      return opts
    end,
  },

  -- 3. Linter configurations
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      -- Override default arguments for specific linters
      opts.linters = opts.linters or {}
      -- Disable the 'document-start' rule for yamllint
      opts.linters.yamllint = {
        args = { "-d", "document-start" },
      }

      -- Assign linters to specific filetypes
      opts.linters_by_ft = vim.tbl_deep_extend("force", opts.linters_by_ft or {}, {
        dockerfile = { "hadolint" },
      })

      return opts
    end,
  },
}
