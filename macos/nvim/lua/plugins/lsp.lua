-- plugins/lsp.lua

return {
  ---------------------------------------------------------------------------
  -- Mason v2.1.0 - Package Manager
  ---------------------------------------------------------------------------
  {
    "mason-org/mason.nvim",
    lazy = false,
    opts = {
      registries = {
        "github:mason-org/mason-registry",
      },
      ui = {
        border = "rounded",
      },
    },
  },

  ---------------------------------------------------------------------------
  -- Mason LSPConfig - Automatic LSP installation
  ---------------------------------------------------------------------------
  {
    "mason-org/mason-lspconfig.nvim",
    lazy = false,
    dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" },
    opts = {
      ensure_installed = {
        "lua_ls",
        "basedpyright",
        "ruff",
        "gopls",
        "bashls",
        "dockerls",
        "groovy_ls",
        "ts_ls",
        "html",
        "cssls",
        "jsonls",
        "terraformls",
        "tflint",
      },
      automatic_install = true,

      handlers = {
        ---------------------------------------------------------------------
        -- Default LSP setup (Blink auto-injects capabilities)
        ---------------------------------------------------------------------
        function(server_name)
          require("lspconfig")[server_name].setup({})
        end,

        ---------------------------------------------------------------------
        -- Lua LS
        ---------------------------------------------------------------------
        lua_ls = function()
          require("lspconfig").lua_ls.setup({
            settings = {
              Lua = {
                diagnostics = { globals = { "vim" } },
                completion = { callSnippet = "Replace" },
                telemetry = { enable = false },
              },
            },
          })
        end,

        ---------------------------------------------------------------------
        -- BasedPyright
        ---------------------------------------------------------------------
        basedpyright = function()
          require("lspconfig").basedpyright.setup({
            settings = {
              python = {
                analysis = {
                  typeCheckingMode = "basic",
                  diagnosticMode = "workspace",
                  autoImportCompletions = true,
                },
              },
            },
          })
        end,

        ---------------------------------------------------------------------
        -- Go (gopls)
        ---------------------------------------------------------------------
        gopls = function()
          require("lspconfig").gopls.setup({
            settings = {
              gopls = {
                usePlaceholders = true,
                staticcheck = true,
                gofumpt = true,
              },
            },
          })
        end,

        ---------------------------------------------------------------------
        -- Terraform LSP
        ---------------------------------------------------------------------
        terraformls = function()
          require("lspconfig").terraformls.setup({
            settings = {
              terraform = {
                hashicorp = {
                  terraform = {
                    validation = { enableEnhancedValidation = true },
                  },
                },
              },
            },
          })
        end,

        ---------------------------------------------------------------------
        -- TFLint
        ---------------------------------------------------------------------
        tflint = function()
          require("lspconfig").tflint.setup({})
        end,
      },
    },
  },

  ---------------------------------------------------------------------------
  -- Core LSPConfig - Keymaps, diagnostics, formatting integration
  ---------------------------------------------------------------------------
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      -----------------------------------------------------------------------
      -- Keymaps for LSP
      -----------------------------------------------------------------------
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("LspKeymaps", { clear = true }),
        callback = function(event)
          local opts = { buffer = event.buf, silent = true }

          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
          vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

          -- Format (LSP or fallback formatter)
          vim.keymap.set("n", "<leader>f", function()
            require("conform").format({ async = true, lsp_fallback = true })
          end, opts)

          vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)
        end,
      })

      -----------------------------------------------------------------------
      -- Diagnostic signs
      -----------------------------------------------------------------------
      local signs = { Error = "✘", Warn = "▲", Hint = "◆", Info = "●" }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end
    end,
  },

  ---------------------------------------------------------------------------
  -- Completion Engine: blink.cmp (Replaces nvim-cmp fully)
  ---------------------------------------------------------------------------
  {
    "saghen/blink.cmp",
    lazy = false,
    version = "*",
    opts = {
      keymap = {
        preset = "default",
      },
      completion = {
        documentation = { auto_show = true },
      },
      signature = {
        enabled = true,
      },
      sources = {
        default = { "lsp", "path", "buffer" },
      },
    },
  },
}
