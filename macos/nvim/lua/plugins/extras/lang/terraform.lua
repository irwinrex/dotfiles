return {
  ----------------------------------------------------------------------
  -- Terraform Language Server (terraform-ls) Setup
  ----------------------------------------------------------------------
  {
    "neovim/nvim-lspconfig",
    ft = { "terraform", "terraform-vars" },
    opts = function()
      return {
        servers = {
          terraformls = {
            filetypes = { "terraform", "terraform-vars" },
            settings = {
              terraform = {
                format = { enable = true }, -- Enable built-in formatter
                languageServer = {
                  indexWorkspace = true, -- Index workspace files for better diagnostics
                  experimentalFeatures = {
                    validateOnSave = true, -- Run validation on save
                  },
                  diagnostics = {
                    enable = true,
                    -- Filter out noisy or unwanted diagnostics
                    ignoredDiagnosticNames = { "Unexpected attribute", "Argument or block definition required" },
                    ignoredRules = {
                      "TF_UNKNOWN_PROVIDER", -- Ignore unknown provider errors
                      "TF_VAR_NOT_FOUND", -- Ignore missing terraform var errors
                      "TF_MISSING_MODULE", -- Ignore missing module errors
                    },
                  },
                  -- Ignore some directories to improve performance and avoid noise
                  ignoreDirectoryNames = { ".terraform", "node_modules" },
                },
              },
            },
            on_init = function(client)
              -- Disable built-in LSP formatting if external formatters like terraform fmt or conform.nvim are used
              client.server_capabilities.documentFormattingProvider = false
              -- Notify server that configuration has changed (helps refresh settings)
              vim.defer_fn(function()
                vim.lsp.buf_notify(0, "workspace/didChangeConfiguration", {})
              end, 1000)
            end,
          },
        },
      }
    end,
    config = function(_, opts)
      local lspconfig = require("lspconfig")
      for server, cfg in pairs(opts.servers or {}) do
        lspconfig[server].setup(cfg)
      end
      -- Optional: setup formatter autocommand here if you use terraform fmt or conform.nvim
    end,
  },

  ----------------------------------------------------------------------
  -- Terraform Linter (TFLint) Setup with lint-on-save
  ----------------------------------------------------------------------
  {
    "mfussenegger/nvim-lint",
    ft = { "terraform", "terraform-vars" },
    opts = {
      linters_by_ft = {
        terraform = { "tflint" },
        ["terraform-vars"] = { "tflint" },
      },
    },
    config = function(_, opts)
      local lint = require("lint")
      for ft, linters in pairs(opts.linters_by_ft) do
        lint.linters_by_ft[ft] = linters
      end
      -- Run TFLint on save for Terraform files
      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        pattern = { "*.tf", "*.tfvars" },
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },
}
