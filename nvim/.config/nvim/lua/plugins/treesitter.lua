local parsers = {
  "bash",
  "c",
  "css",
  "dockerfile",
  "go",
  "hcl",
  "html",
  "javascript",
  "json",
  "lua",
  "markdown",
  "markdown_inline",
  "python",
  "query",
  "regex",
  "rust",
  "sql",
  "terraform",
  "toml",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "yaml",
}

local function start_treesitter(bufnr)
  if not vim.api.nvim_buf_is_valid(bufnr) then return end
  local lang = vim.treesitter.language.get_lang(vim.bo[bufnr].filetype)
  if not lang then return end
  if not pcall(vim.treesitter.start, bufnr, lang) then return end
  vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
end

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  event = { "BufReadPost", "BufNewFile" },
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").install(parsers)

    vim.api.nvim_create_autocmd("FileType", {
      callback = function(args)
        start_treesitter(args.buf)
      end,
    })

    -- FileType may already have fired for the buffer that loaded this plugin.
    start_treesitter(vim.api.nvim_get_current_buf())
  end,
}
