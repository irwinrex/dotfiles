return {
  "folke/snacks.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    dashboard = {
      enabled = true,
      preset = {
        name = "default",
        header = table.concat({
          "██╗██████╗ ██╗    ██╗██╗███╗   ██╗    ██████╗ ███████╗██╗  ██╗",
          "██║██╔══██╗██║    ██║██║████╗  ██║    ██╔══██╗██╔════╝╚██╗██╔╝",
          "██║██████╔╝██║ █╗ ██║██║██╔██╗ ██║    ██████╔╝█████╗   ╚███╔╝ ",
          "██║██╔══██╗██║███╗██║██║██║╚██╗██║    ██╔══██╗██╔══╝   ██╔██╗ ",
          "██║██║  ██║╚███╔███╔╝██║██║ ╚████║    ██║  ██║███████╗██╔╝ ██╗",
          "╚═╝╚═╝  ╚═╝ ╚══╝╚══╝ ╚═╝╚═╝  ╚═══╝    ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝",
          "",
          "      Welcome back, Good luck for zero bugs ! 🚀",
        }, "\n"),
        keys = {
          { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
          { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
          { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
      },
      sections = {
        { section = "header" },
        { section = "keys", gap = 1, padding = 1 },
        { section = "startup" },
      },
    },
    bigfile = {},
    indent = {},
    input = {},
    notifier = { timeout = 3000 },
    quickfile = {},
    scope = {},
    scroll = {},
    words = {},
    bufdelete = {},
    debug = {},
    dim = { enabled = true },
    gh = {},
    git = {},
    gitbrowse = {},
    image = {},
    keymap = {},
    rename = {},
    statuscolumn = { enabled = true },
    toggle = {},
    lazygit = {
      win = { border = "rounded" },
    },
    terminal = {},
    scratch = {},
    zen = {},
    explorer = {
      hidden = true,
      ignored = true,
    },
    picker = {
      hidden = true,
      ignored = true,
      sources = {
        files = { hidden = true, ignored = true },
        explorer = { include = { ".gitignore" } },
      },
      actions = {
        opencode_send = function(picker)
          local items = vim.tbl_map(function(item)
            return item.file
              and require("opencode").format({ path = item.file, from = item.pos, to = item.end_pos })
              or item.text
          end, picker:selected({ fallback = true }))
          require("opencode").prompt(table.concat(items, ", ") .. " ")
        end,
      },
      win = {
        input = {
          keys = {
            ["<a-a>"] = { "opencode_send", mode = { "n", "i" } },
          },
        },
      },
    },
  },
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        _G.dd = function(...)
          Snacks.debug.inspect(...)
        end
        _G.bt = function()
          Snacks.debug.backtrace()
        end
        Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
        Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
        Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
        Snacks.toggle.diagnostics():map("<leader>ud")
        Snacks.toggle.line_number():map("<leader>ul")
        Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map("<leader>uc")
        Snacks.toggle.treesitter():map("<leader>uT")
        Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
        Snacks.toggle.inlay_hints():map("<leader>uh")
        Snacks.toggle.indent():map("<leader>ug")
        Snacks.toggle.dim():map("<leader>uD")
      end,
    })
  end,
  keys = {
    { "<leader>l", function() require("lazy").show() end, desc = "Lazy Dashboard" },
    { "<leader><leader>", function() Snacks.picker.files() end, desc = "Find Files (Root Dir)" },
    { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files (Root Dir)" },
    { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
    { "<leader>fh", function() Snacks.picker.help() end, desc = "Help Tags" },
    { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent Files" },
    { "<leader>fk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
    { "<leader>sG", function() Snacks.picker.grep({ cwd = true }) end, desc = "Grep (cwd)" },
    { "<leader>sR", function() Snacks.picker.resume() end, desc = "Resume" },
    { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
    { "<leader>lg", function() Snacks.lazygit() end, desc = "Lazygit" },
    { "<leader>n", function() Snacks.notifier.show_history() end, desc = "Notification History" },
    { "<leader>tt", function() Snacks.terminal() end, desc = "Toggle Terminal" },
    { "<c-/>", function() Snacks.terminal() end, desc = "Toggle Terminal" },
    { "<leader>z", function() Snacks.zen() end, desc = "Toggle Zen Mode" },
    { "<leader>.", function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
    { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git Browse", mode = { "n", "v" } },
    { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
    { "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands" },
  },
}
