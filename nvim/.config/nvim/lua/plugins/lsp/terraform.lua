-- terraform
return {
  -- 1. THE COMPLETION ENGINE (The "Blink" Era)
  -- Performance-first, replaces nvim-cmp
  {
    "saghen/blink.cmp",
    version = "*", -- Use latest stable
    opts = {
      keymap = { preset = "default" },
      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = "mono",
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
    },
  },

  -- 2. LSP CONFIGURATION
  {
    "neovim/nvim-lspconfig",
    dependencies = { "saghen/blink.cmp" },
    opts = {
      servers = {
        terraformls = {
          -- Blink capabilities are automatically integrated
          root_dir = require("lspconfig.util").root_pattern("terragrunt.hcl", ".terraform", ".git", "main.tf"),
          settings = {
            terraform = {
              experimentalFeatures = {
                prefillRequiredFields = true, -- Modern DX
              },
            },
          },
        },
      },
    },
    config = function(_, opts)
      local lspconfig = require("lspconfig")
      for server, config in pairs(opts.servers) do
        -- Simplified capabilities injection via Blink
        config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
        lspconfig[server].setup(config)
      end

      -- Modern performance: Use global LspAttach instead of per-server on_attach
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          -- Delegate formatting to conform.nvim
          if client and client.name == "terraformls" then
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
          end
        end,
      })
    end,
  },

  -- 3. TOOL INSTALLER (Single source of truth)
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        "terraform-ls",
        "tflint",
        "stylua", -- Example: essential for nvim config
      },
      auto_update = true,
      run_on_start = true,
    },
  },

  -- 4. FORMATTING (Conform.nvim - The Standard)
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        terraform = { "terraform_fmt" },
        tf = { "terraform_fmt" },
        hcl = { "terraform_fmt" },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
    },
  },

  -- 5. LINTING (Nvim-lint)
  {
    "mfussenegger/nvim-lint",
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        terraform = { "tflint" },
        tf = { "tflint" },
      }

      -- Auto-trigger linting on save and entry
      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },
}
