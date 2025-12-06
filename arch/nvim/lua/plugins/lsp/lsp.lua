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
  -- Mason-LSPConfig (automatic installation + handlers)
  ---------------------------------------------------------------------------
  {
    "mason-org/mason-lspconfig.nvim",
    lazy = false,
    dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" },

    opts = {
      ensure_installed = {
        "lua_ls",
        "basedpyright",
        "ruff_lsp",
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

        -- default handler for MOST servers
        function(server_name)
          require("lspconfig")[server_name].setup({})
        end,

        ---------------------------------------------------------------------
        -- LANGUAGE SPECIFIC HANDLERS
        ---------------------------------------------------------------------

        -- Lua
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

        -- Go
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

        -- TypeScript & JavaScript (ts_ls replaces deprecated tsserver)
        ts_ls = function()
          require("lspconfig").ts_ls.setup({
            settings = {
              typescript = {
                format = { indentSize = 2 },
                preferences = { importModuleSpecifier = "non-relative" },
              },
            },
          })
        end,

        -- HTML
        html = function()
          require("lspconfig").html.setup({
            filetypes = { "html", "templ" },
          })
        end,

        -- CSS
        cssls = function()
          require("lspconfig").cssls.setup({
            settings = {
              css = { validate = true },
              scss = { validate = true },
              less = { validate = true },
            },
          })
        end,

        -- TFLint
        tflint = function()
          require("lspconfig").tflint.setup({})
        end,
      },
    },
  },

  ---------------------------------------------------------------------------
  -- Extend LazyVim built-in LSPConfig
  ---------------------------------------------------------------------------
  {
    "neovim/nvim-lspconfig",
    lazy = false,

    opts = function(_, opts)
      local signs = { Error = "✘", Warn = "▲", Hint = "◆", Info = "●" }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspKeymaps", { clear = true }),
        callback = function(event)
          local lsp_opts = { buffer = event.buf, silent = true }

          vim.keymap.set("n", "gd", vim.lsp.buf.definition, lsp_opts)
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, lsp_opts)
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, lsp_opts)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, lsp_opts)
          vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, lsp_opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, lsp_opts)
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, lsp_opts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, lsp_opts)

          vim.keymap.set("n", "<leader>f", function()
            require("conform").format({ async = true, lsp_fallback = true })
          end, lsp_opts)

          vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, lsp_opts)
        end,
      })

      return opts
    end,
  },

  ---------------------------------------------------------------------------
  -- Completion
  ---------------------------------------------------------------------------
  {
    "saghen/blink.cmp",
    lazy = false,
    version = "*",
    opts = {
      keymap = { preset = "default" },
      completion = { documentation = { auto_show = true } },
      signature = { enabled = true },
      sources = { default = { "lsp", "path", "buffer" } },
    },
  },
}
