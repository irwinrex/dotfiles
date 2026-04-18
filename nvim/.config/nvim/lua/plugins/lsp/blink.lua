-- Consolidated blink.cmp configuration
return {
  {
    "saghen/blink.cmp",
    opts = {
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
