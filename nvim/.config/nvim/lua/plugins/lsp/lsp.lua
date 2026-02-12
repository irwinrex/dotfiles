-- plugins/lsp.lua
return {
  ---------------------------------------------------------------------------
  -- Mason (Package Management)
  ---------------------------------------------------------------------------
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    opts = {
      ui = { border = "rounded" },
      ensure_installed = { "tflint" }, -- Non-LSP tools go here
    },
  },

  ---------------------------------------------------------------------------
  -- Mason-LSPConfig (Automatic Installation only)
  ---------------------------------------------------------------------------
  {
    "williamboman/mason-lspconfig.nvim",
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
      },
      -- 2026 Best Practice: Let nvim-lspconfig handle the setup via 'servers'
      automatic_enable = true,
    },
  },

  ---------------------------------------------------------------------------
  -- nvim-lspconfig (Server Logic & UI)
  ---------------------------------------------------------------------------
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- 1. Modern Diagnostic UI (0.11+ Native signs)
      diagnostics = {
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "✘",
            [vim.diagnostic.severity.WARN] = "▲",
            [vim.diagnostic.severity.HINT] = "◆",
            [vim.diagnostic.severity.INFO] = "●",
          },
        },
      },
      -- 2. Inlay Hints (Built-in standard)
      inlay_hints = { enabled = true },
      -- 3. Server-Specific Settings
      servers = {
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = { globals = { "vim" } },
              completion = { callSnippet = "Replace" },
              telemetry = { enable = false },
            },
          },
        },
        gopls = {
          settings = {
            gopls = {
              usePlaceholders = true,
              staticcheck = true,
              gofumpt = true,
            },
          },
        },
        ts_ls = {
          settings = {
            typescript = {
              format = { indentSize = 2 },
              preferences = { importModuleSpecifier = "non-relative" },
            },
          },
        },
        html = { filetypes = { "html", "templ" } },
        cssls = {
          settings = {
            css = { validate = true },
            scss = { validate = true },
            less = { validate = true },
          },
        },
        terraformls = {},
        tflint = {},
      },
    },
  },

  ---------------------------------------------------------------------------
  -- Completion (blink.cmp)
  ---------------------------------------------------------------------------
  {
    "saghen/blink.cmp",
    opts = {
      keymap = { preset = "default" },
      completion = {
        documentation = { auto_show = true, window = { border = "rounded" } },
        ghost_text = { enabled = true },
      },
      signature = { enabled = true, window = { border = "rounded" } },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
    },
  },
}
