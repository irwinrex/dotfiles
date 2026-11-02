-- Managed by mrcjkb/rustaceanvim (see lua/plugins/rust.lua). Do NOT call
-- vim.lsp.enable("rust_analyzer") here or two clients will attach.
local capabilities = require("blink.cmp").get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities())

vim.g.rustaceanvim = {
  server = {
    capabilities = capabilities,
    -- Scratch .rs files are started as rust-analyzer-standalone from
    -- plugins/rust.lua. This client attaches only to a real project, so an
    -- existing cargo session cannot swallow a lone main.rs (detachedFiles is
    -- fixed at process start and is not updated for extra workspace folders).
    standalone = true,
    auto_attach = function(bufnr)
      if vim.bo[bufnr].buftype ~= "" then return false end
      local path = vim.api.nvim_buf_get_name(bufnr)
      if path == "" or not vim.startswith(vim.fs.normalize(path), "/") then return false end
      if not vim.uv.fs_stat(path) or vim.fn.executable("rust-analyzer") ~= 1 then return false end
      return vim.fs.find({ "Cargo.toml", "rust-project.json" }, {
        upward = true,
        path = vim.fs.dirname(path),
      })[1] ~= nil
    end,
    default_settings = {
      ["rust-analyzer"] = {
        cargo = {
          allTargets = true,
        },
        -- Clippy on this package only. --no-deps skips dependency linting;
        -- workspace = false uses -p instead of --workspace.
        check = {
          command = "clippy",
          extraArgs = { "--no-deps" },
          workspace = false,
        },
        diagnostics = {
          enable = true,
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
          -- Reference counts search the whole crate and refresh with CodeLens.
          references = {
            adt = { enable = false },
            enumVariant = { enable = false },
            method = { enable = false },
            trait = { enable = false },
          },
        },
        inlayHints = {
          enable = true,
          bindingModeHints = { enable = true },
          chainingHints = { enable = true },
          closingBraceHints = { enable = true, minLines = 10 },
          parameterHints = { enable = true },
          typeHints = {
            enable = true,
            hideClosureInitialization = false,
            hideNamedConstructor = false,
          },
          renderColons = true,
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
