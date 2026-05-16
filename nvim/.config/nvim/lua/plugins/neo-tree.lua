return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  cmd = "Neotree",
  keys = {
    { "<leader>e", "<cmd>NeoTree float toggle<cr>", desc = "NeoTree (Root Dir)" },
    { "<leader>E", "<cmd>NeoTree float toggle<cr>", desc = "NeoTree (cwd)" },
    { "<leader>fe", "<cmd>NeoTree float toggle<cr>", desc = "Explorer (Root Dir)" },
    { "<leader>fE", "<cmd>NeoTree float toggle<cr>", desc = "Explorer (cwd)" },
  },
  deactivate = function()
    vim.cmd([[Neotree close]])
  end,
  init = function()
    if vim.fn.argc() == 0 then
      vim.cmd([[Neotree]])
    end
  end,
  opts = {
    sources = { "filesystem", "buffers", "git_status" },
    open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
    filesystem = {
      bind_to_cwd = false,
      follow_current_file = { enabled = true },
      use_libuv_file_watcher = true,
    },
    window = {
      mappings = {
        ["l"] = "open",
        ["h"] = "close_node",
        ["<space>"] = "none",
        ["Y"] = {
          function(state)
            local node = state.tree:get_node()
            local path = node:get_id()
            vim.fn.setreg("+", path, "c")
          end,
          desc = "Copy Path to Clipboard",
        },
        ["O"] = {
          function(state)
            require("lazy.util").open(state.tree:get_node().path, { system = true })
          end,
          desc = "Open with System Application",
        },
      },
    },
    default_component_configs = {
      indent = {
        with_expanders = true,
        expander_collapsed = "▸",
        expander_expanded = "▾",
        expander_highlight = "NeoTreeExpander",
      },
      icon = {
        folder_closed = "󰉋",
        folder_open = "󰝰",
        folder_empty = "󰜌",
        default = "󰈔",
        enable_get_icon = true,
      },
      git_status = {
        symbols = {
          unstaged = "✎",
          staged = "✓",
          conflict = "⚡",
          renamed = "→",
          untracked = "✈",
          ignored = "",
        },
      },
      name = {
        trailing_slash = false,
        use_git_status_colors = true,
        highlight = "NeoTreeFileName",
      },
    },
  },
  config = function(_, opts)
    local icons = require("nvim-web-devicons")
    local highlighted_icons = {}

    local function get_hl_icon(path, is_directory)
      local name = vim.fn.fnamemodify(path, ":t")
      local ext = vim.fn.fnamemodify(path, ":e")

      if is_directory then
        return { icon = "", hl = "NeoTreeFolderIcon" }
      end

      local cached = highlighted_icons[ext]
      if cached then
        return cached
      end

      local icon, hl = icons.get_icon(name, ext, { default = true })
      if hl then
        highlighted_icons[ext] = { icon = icon, hl = hl }
      end
      return { icon = icon or "", hl = hl or "NeoTreeFileIcon" }
    end

    opts.default_component_configs.name.get_icon = function(_, node)
      local result = get_hl_icon(node.path or node.name, node:is_directory())
      return result.icon
    end

    opts.default_component_configs.icon.get_icon = function(_, node)
      local result = get_hl_icon(node.path or node.name, node:is_directory())
      return result.icon
    end

    local fg = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID("Normal")), "fg", "gui")
    vim.api.nvim_create_autocmd("ColorScheme", {
      once = true,
      callback = function()
        vim.api.nvim_set_hl(0, "NeoTreeFolderIcon", { fg = "#6d93d6" })
        vim.api.nvim_set_hl(0, "NeoTreeFileIcon", { fg = fg })
        vim.api.nvim_set_hl(0, "NeoTreeExpander", { fg = "#f9a825" })
        vim.api.nvim_set_hl(0, "NeoTreeFileName", { fg = fg })
      end,
    })

    require("neo-tree").setup(opts)

    vim.api.nvim_create_autocmd("TermClose", {
      pattern = "*lazygit",
      callback = function()
        if package.loaded["neo-tree.sources.git_status"] then
          require("neo-tree.sources.git_status").refresh()
        end
      end,
    })
  end,
}