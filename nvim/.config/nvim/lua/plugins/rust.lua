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

return {
  {
    "mrcjkb/rustaceanvim",
    version = "^6",
    ft = { "rust" },
    init = function()
      -- Fail fast with a clear message if the legacy manual config conflicts.
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("RustDoubleClientGuard", { clear = true }),
        callback = function(args)
          local clients = vim.lsp.get_clients({ bufnr = args.buf, name = "rust_analyzer" })
          if #clients > 1 then
            vim.notify("Two rust_analyzer clients attached; disable manual vim.lsp.enable in lsp/lang/rust.lua", vim.log.levels.WARN)
          end
        end,
      })
    end,
    config = function()
      -- Default on for all buffers; per-buffer enables below cover ordering races.
      pcall(vim.lsp.inlay_hint.enable, true)
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "rust",
        group = vim.api.nvim_create_augroup("RustJetBrainsKeymaps", { clear = true }),
        callback = function(args)
          rust_buffer_keymaps(args.buf)
          -- Fallback: LspAttach may have fired before this config() ran.
          enable_rust_inlay(args.buf)
          if vim.lsp.get_clients({ bufnr = args.buf, name = "rust_analyzer" })[1] then
            pcall(vim.lsp.codelens.refresh, { bufnr = args.buf })
          end
        end,
      })
      -- Inlay hints + CodeLens (runnables) auto-refresh, JetBrains-style.
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("RustInlayLens", { clear = true }),
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client or client.name ~= "rust_analyzer" then return end
          -- Unconditional: provider flag can be nil before workspace init.
          enable_rust_inlay(args.buf)
          if client.server_capabilities.codeLensProvider then
            vim.lsp.codelens.refresh({ bufnr = args.buf })
            vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave" }, {
              buffer = args.buf,
              group = vim.api.nvim_create_augroup("RustCodeLensRefresh" .. args.buf, { clear = true }),
              callback = function() vim.lsp.codelens.refresh({ bufnr = args.buf }) end,
            })
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
