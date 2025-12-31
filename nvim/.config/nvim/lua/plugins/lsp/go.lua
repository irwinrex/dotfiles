-- ~/.config/nvim/lua/plugins/go.lua

return {
  -- 1. Configure go.nvim (The toolbelt)
  {
    "ray-x/go.nvim",
    dependencies = { "ray-x/guihua.lua" },
    ft = { "go", "gomod", "gowork" },
    build = ':lua require("go.install").update_all_sync()', -- installs binaries
    opts = {
      lsp_cfg = false,                                      -- Handled by LazyVim LSP config below
      lsp_gofmt = false,                                    -- Handled by conform.nvim
      lsp_goimport = false,                                 -- Handled by conform.nvim
      max_line_len = 120,
      tag_transform = "camelcase",
      test_runner = "go", -- or "richgo"
    },
  },

  -- 2. Configure gopls (The LSP)
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gopls = {
          settings = {
            gopls = {
              gofumpt = true,
              codelenses = {
                gc_details = false,
                generate = true,
                regenerate_cgo = true,
                run_govulncheck = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
                vendor = true,
              },
              hints = {
                assignVariableTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
              analyses = {
                unusedparams = true,
                shadow = true,
              },
              staticcheck = true,
              completeUnimported = true,
              usePlaceholders = true,
            },
          },
        },
      },
    },
  },

  -- 3. Configure Formatting (The Clean-up)
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        -- goimports-reviser is often preferred over goimports as it organizes imports better
        -- install it via Mason: :MasonInstall goimports-reviser
        go = { "goimports-reviser", "gofumpt" },
      },
    },
  },
}
