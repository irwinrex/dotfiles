-- Managed by mrcjkb/rustaceanvim (see lua/plugins/rust.lua). Do NOT call
-- vim.lsp.enable("rust_analyzer") here or two clients will attach.
local capabilities = require("blink.cmp").get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities())

vim.g.rustaceanvim = {
  server = {
    capabilities = capabilities,
    default_settings = {
      ["rust-analyzer"] = {
        cargo = {
          allTargets = true,
          allFeatures = true,
        },
        check = {
          command = "clippy",
          allTargets = true,
        },
        diagnostics = {
          enable = true,
          styleLints = { enable = true },
        },
        completion = {
          autoimport = { enable = true },
          callable = { snippets = "fill_arguments" },
          full = { snippets = { enable = true } },
        },
        hover = {
          actions = {
            enable = true,
            references = { enable = true },
            run = { enable = true },
            debug = { enable = false },
            gotoTypeDef = { enable = true },
            implementations = { enable = true },
          },
        },
        lens = {
          enable = true,
          run = { enable = true },
          debug = { enable = false },
          implementations = { enable = true },
          references = {
            adt = { enable = true },
            enumVariant = { enable = true },
            method = { enable = true },
            trait = { enable = true },
          },
        },
        inlayHints = {
          enable = true,
          bindingModeHints = { enable = true },
          chainingHints = { enable = true },
          closingBraceHints = { enable = true, minLines = 10 },
          parameterHints = { enable = true },
          expressionAdjustmentHints = {
            enable = "always",
            mode = "prefix",
            hideOutsideUnsafe = false,
          },
          typeHints = {
            enable = true,
            hideClosureInitialization = false,
            hideNamedConstructor = false,
          },
          renderColons = true,
          maxLength = nil,
        },
        procMacro = { enable = true },
        typing = { autoClosingAngleBrackets = { enable = true } },
        files = {
          excludeDirs = { ".git", "node_modules", "vendor", "target" },
          -- Server-side file watching: Neovim's client watcher (re)reads on
          -- FocusGained/BufEnter/CursorHold via checktime; RA watching on the
          -- server side avoids the client scan and double bookkeeping.
          watcher = "server",
        },
        -- JetBrains/RustRover import style: one `use crate::path::Item;` per crate
        -- instead of separate use statements (cleaner diff for RA codeActions).
        imports = { granularity = { group = "crate" } },
      },
    },
  },
  tools = {
    code_actions = { ui_select_fallback = true },
    float_win_config = { border = "rounded" },
  },
}
