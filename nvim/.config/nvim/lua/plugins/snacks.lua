local transparent_winhighlight = table.concat({
  "Normal:SnacksTransparentNormal",
  "NormalNC:SnacksTransparentNormal",
  "NormalFloat:SnacksTransparentNormal",
  "FloatBorder:SnacksTransparentBorder",
  "FloatTitle:SnacksTransparentTitle",
  "FloatFooter:SnacksTransparentTitle",
  "WinSeparator:SnacksTransparentBorder",
}, ",")

local solid_winhighlight = table.concat({
  "Normal:SnacksSolidNormal",
  "NormalNC:SnacksSolidNormal",
  "NormalFloat:SnacksSolidNormal",
  "FloatBorder:SnacksSolidBorder",
  "FloatTitle:SnacksSolidTitle",
  "FloatFooter:SnacksSolidTitle",
  "WinSeparator:SnacksSolidBorder",
}, ",")

local function buffer_is_pinned(buf)
  return vim.api.nvim_buf_is_valid(buf) and vim.b[buf].snacks_pinned == true
end

local function toggle_buffer_pin(buf)
  if not vim.api.nvim_buf_is_valid(buf) then
    return
  end

  vim.b[buf].snacks_pinned = not buffer_is_pinned(buf)
  local state = vim.b[buf].snacks_pinned and "Pinned" or "Unpinned"
  local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":t")
  Snacks.notify.info(("%s %s"):format(state, name ~= "" and name or "[Scratch]"), { title = "Buffers" })
  vim.cmd.redrawtabline()
end

local function format_buffer(item, picker)
  local ret = Snacks.picker.format.buffer(item, picker)
  table.insert(ret, 1, { buffer_is_pinned(item.buf) and " " or "  ", "SnacksPickerBufPin" })

  local diagnostics = vim.diagnostic.count(item.buf)
  local errors = diagnostics[vim.diagnostic.severity.ERROR] or 0
  local warnings = diagnostics[vim.diagnostic.severity.WARN] or 0
  if errors > 0 then
    ret[#ret + 1] = { ("   %d"):format(errors), "DiagnosticError" }
  end
  if warnings > 0 then
    ret[#ret + 1] = { ("   %d"):format(warnings), "DiagnosticWarn" }
  end

  return ret
end

local function toggle_picker_buffer_pin(picker)
  for _, item in ipairs(picker:selected({ fallback = true })) do
    if item.buf then
      toggle_buffer_pin(item.buf)
    end
  end
  picker:refresh()
end

local function delete_buffer_group(direction)
  local current = vim.api.nvim_get_current_buf()
  local listed = vim.tbl_filter(function(buf)
    return vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted
  end, vim.api.nvim_list_bufs())

  local current_index
  for index, buf in ipairs(listed) do
    if buf == current then
      current_index = index
      break
    end
  end
  if not current_index then
    return
  end

  local targets = {}
  for index, buf in ipairs(listed) do
    local matches = direction == "unpinned"
      or (direction == "left" and index < current_index)
      or (direction == "right" and index > current_index)
    if matches and buf ~= current and not buffer_is_pinned(buf) then
      targets[buf] = true
    end
  end

  Snacks.bufdelete.delete({ filter = function(buf) return targets[buf] == true end })
end

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
          {
            icon = " ",
            key = "g",
            desc = "Find Text",
            action = ":lua Snacks.dashboard.pick('live_grep')",
          },
          {
            icon = " ",
            key = "r",
            desc = "Recent Files",
            action = ":lua Snacks.dashboard.pick('oldfiles')",
          },
          {
            icon = " ",
            key = "c",
            desc = "Config",
            action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
          },
          {
            icon = "󰒲 ",
            key = "L",
            desc = "Lazy",
            action = ":Lazy",
            enabled = package.loaded.lazy ~= nil,
          },
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
    keymap = {},
    rename = {},
    statuscolumn = { enabled = true },
    toggle = {},
    styles = {
      dashboard = { wo = { winhighlight = transparent_winhighlight } },
      help = { wo = { winhighlight = solid_winhighlight } },
      lazygit = { wo = { winhighlight = transparent_winhighlight } },
      scratch = { wo = { winhighlight = transparent_winhighlight } },
      terminal = { wo = { winhighlight = transparent_winhighlight } },
    },
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
        buffers = {
          current = true,
          unloaded = true,
          sort_lastused = true,
          format = format_buffer,
          win = {
            input = {
              keys = {
                ["<a-p>"] = { "buffer_pin", mode = { "n", "i" } },
              },
            },
            list = {
              keys = {
                p = "buffer_pin",
              },
            },
          },
        },
        explorer = {
          include = { ".gitignore" },
          on_show = function(picker)
            local winhighlight = transparent_winhighlight
              .. ",CursorLine:SnacksExplorerCursorLine"

            local windows = {
              picker.layout.root.win,
              picker.input.win.win,
              picker.list.win.win,
              picker.preview and picker.preview.win and picker.preview.win.win,
            }
            for _, window in ipairs(windows) do
              if window and vim.api.nvim_win_is_valid(window) then
                vim.wo[window].winhighlight = winhighlight
              end
            end
          end,
        },
      },
      actions = {
        copy_selection = function(picker)
          local items = picker:selected({ fallback = true })
          local lines = vim.tbl_map(function(item)
            return item.text or item.data or ""
          end, items)
          vim.fn.setreg(vim.v.register, table.concat(lines, "\n"))
          Snacks.notify(("Copied %d item(s)"):format(#lines), { title = "Snacks Picker" })
        end,
        buffer_pin = toggle_picker_buffer_pin,
        opencode_send = function(picker)
          local items = vim.tbl_map(
            function(item) return item.file and require("opencode").format({ path = item.file, from = item.pos, to = item.end_pos }) or item.text end,
            picker:selected({ fallback = true })
          )
          require("opencode").prompt(table.concat(items, ", ") .. " ")
        end,
      },
      win = {
        input = {
          keys = {
            ["<a-a>"] = { "opencode_send", mode = { "n", "i" } },
            ["<c-j>"] = false,
            ["<c-k>"] = false,
            ["<c-n>"] = { "list_down", mode = { "i", "n" } },
            ["<c-p>"] = { "list_up", mode = { "i", "n" } },
            ["<c-y>"] = { "confirm", mode = { "i", "n" } },
            ["<c-s-y>"] = { "copy_selection", mode = { "i", "n" } },
          },
        },
        list = {
          keys = {
            ["<c-j>"] = false,
            ["<c-k>"] = false,
            ["<c-n>"] = "list_down",
            ["<c-p>"] = "list_up",
            ["<c-y>"] = "confirm",
            ["<c-s-y>"] = "copy_selection",
            y = "copy_selection",
          },
        },
      },
    },
  },
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        _G.dd = function(...) Snacks.debug.inspect(...) end
        _G.bt = function() Snacks.debug.backtrace() end
        Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
        Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
        Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
        Snacks.toggle.diagnostics():map("<leader>ud")
        Snacks.toggle.line_number():map("<leader>ul")
        Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map("<leader>uc")
        Snacks.toggle.treesitter():map("<leader>uT")
        Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
        Snacks.toggle.indent():map("<leader>ug")
        Snacks.toggle.dim():map("<leader>uD")
      end,
    })
  end,
  keys = {
    {
      "<leader>l",
      function() require("lazy").show() end,
      desc = "Lazy Dashboard",
    },
    {
      "<leader><leader>",
      function() Snacks.picker.files() end,
      desc = "Find Files (Root Dir)",
    },
    {
      "<leader>ff",
      function() Snacks.picker.files() end,
      desc = "Find Files (Root Dir)",
    },
    {
      "<leader>fb",
      function() Snacks.picker.buffers() end,
      desc = "Buffers",
    },
    {
      "<leader>,",
      function() Snacks.picker.buffers() end,
      desc = "Buffers",
    },
    {
      "<leader>fh",
      function() Snacks.picker.help() end,
      desc = "Help Tags",
    },
    {
      "<leader>fr",
      function() Snacks.picker.recent() end,
      desc = "Recent Files",
    },
    {
      "<leader>fk",
      function() Snacks.picker.keymaps() end,
      desc = "Keymaps",
    },
    {
      "<leader>sG",
      function() Snacks.picker.grep({ cwd = true }) end,
      desc = "Grep (cwd)",
    },
    {
      "<leader>sR",
      function() Snacks.picker.resume() end,
      desc = "Resume",
    },
    {
      "<leader>gg",
      function()
        local root = vim.fs.root(0, ".git")
        Snacks.lazygit(root and { cwd = root } or {})
      end,
      desc = "Lazygit (Git Root)",
    },
    {
      "<leader>n",
      function() Snacks.notifier.show_history() end,
      desc = "Notification History",
    },
    {
      "<leader>tt",
      function() Snacks.terminal() end,
      desc = "Toggle Terminal",
    },
    {
      "<c-/>",
      function() Snacks.terminal() end,
      desc = "Toggle Terminal",
    },
    {
      "<leader>z",
      function() Snacks.zen() end,
      desc = "Toggle Zen Mode",
    },
    {
      "<leader>.",
      function() Snacks.scratch() end,
      desc = "Toggle Scratch Buffer",
    },
    {
      "<leader>gB",
      function() Snacks.gitbrowse() end,
      desc = "Git Browse",
      mode = { "n", "v" },
    },
    { "H", "<cmd>bprevious<cr>", desc = "Previous Buffer" },
    { "L", "<cmd>bnext<cr>", desc = "Next Buffer" },
    { "[b", "<cmd>bprevious<cr>", desc = "Previous Buffer" },
    { "]b", "<cmd>bnext<cr>", desc = "Next Buffer" },
    {
      "<leader>bj",
      function() Snacks.picker.buffers() end,
      desc = "Pick Buffer",
    },
    {
      "<leader>bd",
      function() Snacks.bufdelete() end,
      desc = "Delete Buffer",
    },
    {
      "<leader>bP",
      function() delete_buffer_group("unpinned") end,
      desc = "Delete Non-Pinned Buffers",
    },
    {
      "<leader>bp",
      function() toggle_buffer_pin(vim.api.nvim_get_current_buf()) end,
      desc = "Toggle Buffer Pin",
    },
    {
      "<leader>bl",
      function() delete_buffer_group("left") end,
      desc = "Delete Buffers to the Left",
    },
    {
      "<leader>br",
      function() delete_buffer_group("right") end,
      desc = "Delete Buffers to the Right",
    },
    {
      "<leader>xx",
      function() Snacks.picker.diagnostics_buffer() end,
      desc = "Buffer Diagnostics",
    },
    {
      "<leader>xX",
      function() Snacks.picker.diagnostics() end,
      desc = "Workspace Diagnostics",
    },
    {
      "<leader>xe",
      function() Snacks.picker.diagnostics({ severity = vim.diagnostic.severity.ERROR }) end,
      desc = "Workspace Errors",
    },
    {
      "<leader>xE",
      function() Snacks.picker.diagnostics_buffer({ severity = vim.diagnostic.severity.ERROR }) end,
      desc = "Buffer Errors",
    },
    {
      "<leader>xs",
      function() Snacks.picker.lsp_symbols() end,
      desc = "Document Symbols",
    },
    {
      "<leader>xl",
      function() Snacks.picker.lsp_references() end,
      desc = "LSP References",
    },
    {
      "<leader>xL",
      function() Snacks.picker.loclist() end,
      desc = "Location List",
    },
    {
      "<leader>xq",
      function() Snacks.picker.qflist() end,
      desc = "Quickfix List",
    },
    {
      "<leader>sC",
      function() Snacks.picker.commands() end,
      desc = "Commands",
    },
  },
}
