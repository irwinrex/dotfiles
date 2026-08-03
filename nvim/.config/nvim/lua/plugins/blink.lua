-- ~/.config/nvim/lua/plugins/blink.lua
return {
  "saghen/blink.cmp",
  version = "1.*",                       -- v1.x stable, prebuilt binaries
  lazy = false,                          -- LSP capabilities are built during startup
  dependencies = {
    "rafamadriz/friendly-snippets",     -- optional snippets
  },
  opts = {
    keymap = {
      preset = "none",
      ["<c-n>"] = { "select_next", "fallback" },
      ["<c-p>"] = { "select_prev", "fallback" },
      ["<c-y>"] = { "select_and_accept", "fallback" },
    },
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },
    appearance = {
      use_nvim_cmp_as_default = false,
      nerd_font_variant = "mono",
      kind_icons = { Text = "󰉿", Method = "󰊕", Function = "󰊕" },
    },
    completion = {
      accept = { auto_brackets = { enabled = true } },
      list = {
        selection = {
          preselect = true,
          auto_insert = false,
        },
      },
      documentation = { auto_show = true, auto_show_delay_ms = 200 },
      menu = {
        draw = {
          treesitter = { "lsp" },
          columns = { { "kind_icon" }, { "label", "label_description", gap = 1 }, { "kind" } },
        },
      },
      ghost_text = { enabled = true },
    },
    signature = { enabled = true },
    fuzzy = {
      implementation = "prefer_rust_with_warning",
      prebuilt_binaries = { download = true },
    },
    cmdline = {
      enabled = true,
      keymap = { preset = "cmdline" },
      completion = { menu = { auto_show = true }, list = { selection = { preselect = false } } },
    },
  },
}
