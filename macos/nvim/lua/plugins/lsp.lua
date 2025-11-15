-- plugins/lsp.lua

return {
  -- Mason v2.1.0 - Latest Package Manager (Nov 2025)
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

  -- Mason LSPConfig - Now tightly integrated with mason v2.1.0
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
        function(server_name)
          require("lspconfig")[server_name].setup({
            capabilities = require("cmp_nvim_lsp").default_capabilities(),
          })
        end,
        lua_ls = function()
          require("lspconfig").lua_ls.setup({
            capabilities = require("cmp_nvim_lsp").default_capabilities(),
            settings = {
              Lua = {
                diagnostics = { globals = { "vim" } },
                completion = { callSnippet = "Replace" },
                telemetry = { enable = false },
              },
            },
          })
        end,
        basedpyright = function()
          require("lspconfig").basedpyright.setup({
            capabilities = require("cmp_nvim_lsp").default_capabilities(),
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
        gopls = function()
          require("lspconfig").gopls.setup({
            capabilities = require("cmp_nvim_lsp").default_capabilities(),
            settings = {
              gopls = {
                usePlaceholders = true,
                staticcheck = true,
                gofumpt = true,
              },
            },
          })
        end,
        terraformls = function()
          require("lspconfig").terraformls.setup({
            capabilities = require("cmp_nvim_lsp").default_capabilities(),
            settings = {
              terraform = {
                hashicorp = {
                  terraform = {
                    validation = {
                      enableEnhancedValidation = true,
                    },
                  },
                },
              },
            },
          })
        end,
        tflint = function()
          require("lspconfig").tflint.setup({
            capabilities = require("cmp_nvim_lsp").default_capabilities(),
          })
        end,
      },
    },
  },

  -- LSPConfig v2 - Core LSP client for Neovim v0.11
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    config = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("LspKeymaps", { clear = true }),
        callback = function(event)
          local opts = { buffer = event.buf, silent = true }

          vim.keymap.set(
            "n",
            "gd",
            vim.lsp.buf.definition,
            vim.tbl_extend("force", opts, { desc = "Go to definition" })
          )
          vim.keymap.set(
            "n",
            "gD",
            vim.lsp.buf.declaration,
            vim.tbl_extend("force", opts, { desc = "Go to declaration" })
          )
          vim.keymap.set(
            "n",
            "gi",
            vim.lsp.buf.implementation,
            vim.tbl_extend("force", opts, { desc = "Go to implementation" })
          )
          vim.keymap.set("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "Find references" }))
          vim.keymap.set(
            "n",
            "gt",
            vim.lsp.buf.type_definition,
            vim.tbl_extend("force", opts, { desc = "Go to type definition" })
          )
          vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover documentation" }))
          vim.keymap.set(
            "n",
            "<leader>ca",
            vim.lsp.buf.code_action,
            vim.tbl_extend("force", opts, { desc = "Code action" })
          )
          vim.keymap.set(
            "n",
            "<leader>rn",
            vim.lsp.buf.rename,
            vim.tbl_extend("force", opts, { desc = "Rename symbol" })
          )
          vim.keymap.set("n", "<leader>f", function()
            vim.lsp.buf.format({ async = true })
          end, vim.tbl_extend("force", opts, { desc = "Format code" }))
          vim.keymap.set("n", "<leader>f", function()
            vim.lsp.buf.format({ async = true })
          end, vim.tbl_extend("force", opts, { desc = "Format code" }))
          vim.keymap.set("n", "<leader>f", function()
            require("conform").format({ async = true, lsp_fallback = true })
          end, vim.tbl_extend("force", opts, { desc = "Format code" }))
          vim.keymap.set(
            "n",
            "<leader>d",
            vim.diagnostic.open_float,
            vim.tbl_extend("force", opts, { desc = "Show diagnostics" })
          )
        end,
      })

      local signs = { Error = "✘", Warn = "▲", Hint = "◆", Info = "●" }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end
    end,
  },

  -- Completion plugin (hrsh7th/nvim-cmp)
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },

  -- Snippet engine
  {
    "L3MON4D3/LuaSnip",
    lazy = true,
  },
}
