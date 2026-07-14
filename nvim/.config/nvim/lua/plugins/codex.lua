return {
  "ishiooon/codex.nvim",
  dependencies = { "folke/snacks.nvim" },
  cmd = {
    "Codex",
    "CodexFocus",
    "CodexMaximizeToggle",
    "CodexSend",
    "CodexTreeAdd",
  },
  keys = {
    { "<leader>cc", "<cmd>Codex<cr>", desc = "Codex: Toggle" },
    { "<leader>cf", "<cmd>CodexFocus<cr>", desc = "Codex: Focus" },
    { "<leader>cm", "<cmd>CodexMaximizeToggle<cr>", desc = "Codex: Toggle modal" },
    { "<leader>cs", "<cmd>CodexSend<cr>", mode = "v", desc = "Codex: Send selection" },
  },
  opts = {},
}
