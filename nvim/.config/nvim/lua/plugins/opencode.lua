return {
  "nickjvandyke/opencode.nvim",
  version = "*",
  cmd = "OpenCode",
  config = function()
    vim.g.opencode_opts = {
      server = {
        start = function()
          require("snacks.terminal").open("opencode --port", {
            win = { position = "right", enter = false },
          })
        end,
      },
    }

    vim.o.autoread = true

    vim.api.nvim_create_user_command("OpenCode", function()
      require("snacks.terminal").toggle("opencode --port", {
        win = { position = "right", enter = false },
      })
    end, { desc = "Toggle OpenCode AI terminal" })
  end,
}
