return {
  -- Configure LSP servers
  servers = {
    -- ===== GO Configuration =====
    gopls = {
      settings = {
        gopls = {
          completeUnimported = true,
          usePlaceholders = true,
          analyses = {
            unusedparams = true,
            shadow = true,
          },
          staticcheck = true,
          gofumpt = true,
          semanticTokens = true,
          hints = {
            assignVariableTypes = true,
            compositeLiteralFields = true,
            compositeLiteralTypes = true,
            constantValues = true,
            functionTypeParameters = true,
            parameterNames = true,
            rangeVariableTypes = true,
          },
        },
      },
      on_attach = function(client, bufnr)
        -- Custom keymaps for Go
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end

        map("n", "<leader>ct", "<cmd>lua require('go.test').test()<CR>", "Go Test")
        map("n", "<leader>cT", "<cmd>lua require('go.test').test_file()<CR>", "Go Test File")
        map("n", "<leader>cr", "<cmd>lua require('go.run').run()<CR>", "Go Run")
      end,
    },

    -- ===== Python Configuration =====
    pyright = {
      settings = {
        pyright = {
          -- Using pyright's native type checking instead of pylance
          disableOrganizeImports = false,
          analysis = {
            typeCheckingMode = "basic", -- "off", "basic", "strict"
            autoSearchPaths = true,
            useLibraryCodeForTypes = true,
            diagnosticMode = "openFilesOnly", -- "openFilesOnly", "workspace"
            autoImportCompletions = true,
          },
        },
      },
    },

    -- Alternative: Use ruff_lsp for faster linting + formatting
    ruff_lsp = {
      on_attach = function(client, bufnr)
        -- Disable hover in favor of Pyright
        client.server_capabilities.hoverProvider = false
      end,
    },

    -- ===== Terraform Configuration =====
    terraformls = {
      filetypes = { "terraform", "tf", "hcl" },
      on_attach = function(client, bufnr)
        -- Enable formatting with terraform_fmt
        client.server_capabilities.documentFormattingProvider = true
      end,
    },

    tflint = {
      filetypes = { "terraform", "tf", "hcl" },
    },

    -- ===== Docker Configuration =====
    dockerls = {},
    docker_compose_language_service = {},

    -- ===== Additional Language Support =====
    bashls = {}, -- Often useful with Docker
    jsonls = {
      settings = {
        json = {
          schemas = require("schemastore").json.schemas(),
          validate = { enable = true },
        },
      },
    },
    yamlls = {
      settings = {
        yaml = {
          schemas = require("schemastore").yaml.schemas(),
          keyOrdering = false,
        },
      },
    },
  },

  -- Mason setup - ensure all LSP servers and tools are installed
  setup = {
    -- ===== Go Tools =====
    gopls = function(_, opts)
      -- Ensure delve (debugger) is installed for Go
      local mason_registry = require("mason-registry")
      if not mason_registry.is_installed("delve") then
        vim.cmd("MasonInstall delve")
      end
    end,

    -- ===== Python Setup =====
    pyright = function(_, opts)
      -- Ensure debugpy is installed for Python debugging
      local mason_registry = require("mason-registry")
      if not mason_registry.is_installed("debugpy") then
        vim.cmd("MasonInstall debugpy")
      end
    end,

    -- ===== Terraform Setup =====
    terraformls = function(_, opts)
      -- Ensure tflint is installed
      local mason_registry = require("mason-registry")
      if not mason_registry.is_installed("tflint") then
        vim.cmd("MasonInstall tflint")
      end
    end,

    -- ===== Ruff LSP Setup =====
    ruff_lsp = function()
      -- Load ruff_lsp only if installed
      local mason_registry = require("mason-registry")
      if mason_registry.is_installed("ruff-lsp") then
        require("lspconfig").ruff_lsp.setup({
          init_options = {
            settings = {
              args = {},
            },
          },
        })
      end
    end,
  },
}
