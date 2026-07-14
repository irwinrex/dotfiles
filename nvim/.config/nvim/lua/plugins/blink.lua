-- ~/.config/nvim/lua/plugins/blink.lua
return {
  "saghen/blink.cmp",
  version = "1.*",                       -- v1.x stable, prebuilt binaries
  event = { "InsertEnter", "CmdlineEnter" },
  dependencies = {
    "rafamadriz/friendly-snippets",     -- optional snippets
  },
  opts = {
    keymap = {
      preset = "default",
      ["<C-y>"] = { "select_and_accept" },
      ["<CR>"] = { "select_and_accept", "fallback" },
      ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
      ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
      ["<C-e>"] = { "hide", "fallback" },
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
