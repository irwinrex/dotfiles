-- JetBrains-level Rust LSP-only: rustaceanvim (runnables/testables, hover
-- actions, lens, inlay hints) + crates.nvim. No DAP / no test UI.
-- Server settings live in lsp/lang/rust.lua via vim.g.rustaceanvim (loaded at
-- startup before this ft plugin activates). This file only declares plugins
-- and Rust-buffer keymaps/autocmds.

local function rust_buffer_keymaps(bufnr)
  local function opts(desc) return { buffer = bufnr, silent = true, desc = desc } end
  local function cmd(c) return "<cmd>" .. c .. "<CR>" end

  -- Runnables / testables (cargo run/test, no debugger)
  vim.keymap.set("n", "<leader>rr", cmd("RustLsp runnables"), opts("Rust runnables"))
  vim.keymap.set("n", "<leader>rt", cmd("RustLsp testables"), opts("Rust testables"))
  -- Hover / actions
  vim.keymap.set("n", "K", cmd("RustLsp hover actions"), opts("Rust hover actions"))
  vim.keymap.set("n", "<leader>ca", cmd("RustLsp codeAction"), opts("Rust code action"))
  -- Refactor / navigate (JetBrains Alt+Enter / Alt+Up parity)
  vim.keymap.set("n", "<leader>re", cmd("RustLsp expandMacro"), opts("Rust expand macro"))
  vim.keymap.set("n", "<leader>rp", cmd("RustLsp parentModule"), opts("Rust parent module"))
  vim.keymap.set("n", "<leader>rj", cmd("RustLsp joinLines"), opts("Rust join lines"))
  vim.keymap.set("v", "<leader>rj", "<cmd>RustLsp joinLines<CR>", opts("Rust join lines"))
  -- Reformat selection (JetBrains Ctrl+Alt+Shift+R parity); requires RA's
  -- textDocument/rangeFormatting. Esc falls back to rustfmt via conform.
  vim.keymap.set("v", "<leader>rf", function()
    local client = vim.lsp.get_clients({ bufnr = bufnr, name = "rust-analyzer" })[1]
      or vim.lsp.get_clients({ bufnr = bufnr, name = "rust-analyzer-standalone" })[1]
    vim.lsp.buf.format({
      name = client and client.name or "rust-analyzer",
      async = true,
      range = {
        start = { vim.fn.getpos("'<")[2], vim.fn.getpos("'<")[3] - 1 },
        ["end"] = { vim.fn.getpos("'>")[2], vim.fn.getpos("'>")[3] },
      },
    })
  end, opts("Rust format selection"))
  vim.keymap.set("n", "<leader>ro", cmd("RustLsp openDocsRs"), opts("Rust open docs.rs"))
  vim.keymap.set("n", "<leader>rx", cmd("RustLsp explainError"), opts("Rust explain error"))
  vim.keymap.set("n", "<leader>rc", cmd("RustLsp openCargo"), opts("Rust open Cargo.toml"))
  vim.keymap.set("n", "<leader>rR", cmd("RustLsp workspaceReload"), opts("Rust reload workspace"))
  vim.keymap.set("n", "<leader>uh", function()
    local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
    vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
  end, opts("Rust toggle inlay hints"))
end

local function enable_rust_inlay(bufnr)
  pcall(vim.lsp.inlay_hint.enable, true, { bufnr = bufnr })
end

local standalone_name = "rust-analyzer-standalone"

local function rust_lsp_client(bufnr)
  return vim.lsp.get_clients({ bufnr = bufnr, name = "rust-analyzer" })[1]
    or vim.lsp.get_clients({ bufnr = bufnr, name = standalone_name })[1]
end

local function project_manifest(path)
  return vim.fs.find({ "Cargo.toml", "rust-project.json" }, {
    upward = true,
    path = vim.fs.dirname(path),
  })[1]
end

-- Lone .rs file: absolute, on disk, and not inside a Cargo / rust-project tree.
local function scratch_path(bufnr)
  if vim.bo[bufnr].buftype ~= "" then return nil end
  local path = vim.api.nvim_buf_get_name(bufnr)
  if path == "" or not vim.startswith(vim.fs.normalize(path), "/") then return nil end
  if not vim.uv.fs_stat(path) or project_manifest(path) then return nil end
  return path
end

local function start_standalone(bufnr)
  local path = scratch_path(bufnr)
  if not path then return end
  if vim.lsp.get_clients({ bufnr = bufnr, name = standalone_name })[1] then return end
  local bin = vim.fn.exepath("rust-analyzer")
  if bin == "" then return end

  -- No clippy: `check.command = "clippy"` is cargo, and there is no manifest.
  -- Type errors for std still come from the detached crate.
  local ra_settings = {
    checkOnSave = false,
    procMacro = { enable = false },
  }
  local server = (vim.g.rustaceanvim or {}).server
  vim.lsp.start({
    name = standalone_name,
    cmd = { bin },
    root_dir = vim.fs.dirname(path),
    filetypes = { "rust" },
    capabilities = server and server.capabilities or nil,
    settings = { ["rust-analyzer"] = ra_settings },
    -- rust-analyzer reads these from initializationOptions at startup.
    init_options = vim.tbl_extend("force", ra_settings, { detachedFiles = { path } }),
  }, {
    bufnr = bufnr,
    -- reuse_client is an opts field, not a client config field. detachedFiles
    -- is fixed for the process, so a second scratch file in the same directory
    -- (same root_dir) must not reuse a client started for a different path.
    reuse_client = function(client, config)
      local existing = vim.tbl_get(client, "config", "init_options", "detachedFiles") or {}
      local wanted = vim.tbl_get(config, "init_options", "detachedFiles") or {}
      return client.name == config.name and existing[1] == wanted[1]
    end,
  })
end

-- New file inside a cargo project: rustaceanvim skips it until the file
-- exists, and re-firing FileType does not source ftplugin/rust.lua.
local function start_cargo_if_needed(bufnr)
  if vim.bo[bufnr].buftype ~= "" then return end
  local path = vim.api.nvim_buf_get_name(bufnr)
  if path == "" or not vim.uv.fs_stat(path) or not project_manifest(path) then return end
  if vim.lsp.get_clients({ bufnr = bufnr, name = "rust-analyzer" })[1] then return end
  if vim.fn.executable("rust-analyzer") ~= 1 then return end
  local ok, lsp = pcall(require, "rustaceanvim.lsp")
  if ok then lsp.start(bufnr) end
end

return {
  {
    "mrcjkb/rustaceanvim",
    version = "^9",
    ft = { "rust" },
    init = function()
      -- Fail fast with a clear message if the legacy manual config conflicts.
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("RustDoubleClientGuard", { clear = true }),
        callback = function(args)
          local clients = vim.lsp.get_clients({ bufnr = args.buf, name = "rust-analyzer" })
          if #clients > 1 then
            vim.notify("Two rust-analyzer clients attached; disable manual vim.lsp.enable in lsp/lang/rust.lua", vim.log.levels.WARN)
          end
        end,
      })

      -- Scratch files: start once the path exists. FileType often fires before
      -- the first :w, and re-firing FileType does not call lsp.start.
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "rust",
        group = vim.api.nvim_create_augroup("RustStandaloneAttach", { clear = true }),
        callback = function(args)
          start_standalone(args.buf)
        end,
      })
      vim.api.nvim_create_autocmd("BufWritePost", {
        pattern = "*.rs",
        group = vim.api.nvim_create_augroup("RustAutoAttachOnSave", { clear = true }),
        callback = function(args)
          start_standalone(args.buf)
          start_cargo_if_needed(args.buf)
        end,
      })
    end,
    config = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "rust",
        group = vim.api.nvim_create_augroup("RustJetBrainsKeymaps", { clear = true }),
        callback = function(args)
          rust_buffer_keymaps(args.buf)
          -- Fallback: LspAttach may have fired before this config() ran.
          enable_rust_inlay(args.buf)
          if rust_lsp_client(args.buf) then
            -- 0.12: codelens.refresh() is deprecated; enable() is the
            -- self-managing API (nvim refreshes codelens automatically).
            pcall(vim.lsp.codelens.enable, true, { bufnr = args.buf })
          end
        end,
      })
      -- Inlay hints + CodeLens (runnables) auto-refresh, JetBrains-style.
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("RustInlayLens", { clear = true }),
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client or (client.name ~= "rust-analyzer" and client.name ~= standalone_name) then return end
          -- Unconditional: provider flag can be nil before workspace init.
          enable_rust_inlay(args.buf)
          if client.server_capabilities.codeLensProvider then
            -- 0.12: enable() is the supported API — nvim owns refreshing
            -- (runnables stay live with no manual BufEnter/InsertLeave churn).
            pcall(vim.lsp.codelens.enable, true, { bufnr = args.buf })
          end
        end,
      })
    end,
  },
  {
    "Saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    opts = {},
    config = function(_, opts)
      require("crates").setup(opts)
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "toml",
        group = vim.api.nvim_create_augroup("CratesKeymaps", { clear = true }),
        callback = function(args)
          if vim.fn.expand("%:t") ~= "Cargo.toml" then return end
          local function b(desc) return { buffer = args.buf, silent = true, desc = desc } end
          vim.keymap.set("n", "<leader>cu", function() require("crates").upgrade_all_crates() end, b("Crates upgrade all"))
          vim.keymap.set("n", "<leader>cU", function() require("crates").update_all_crates() end, b("Crates update all"))
          vim.keymap.set("n", "<leader>cd", function() require("crates").open_documentation() end, b("Crates docs"))
          vim.keymap.set("n", "<leader>ch", function() require("crates").show_popup() end, b("Crates popup"))
        end,
      })
    end,
  },
}
