return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  build = function()
    require("nvim-treesitter").install({
      "bash", "c", "css", "dockerfile", "go", "hcl", "html",
      "javascript", "json", "lua", "markdown", "markdown_inline",
      "python", "query", "rust", "sql", "terraform", "toml",
      "typescript", "vim", "vimdoc", "yaml",
    })
  end,
  init = function()
    vim.treesitter.language.register("hcl", "terraform")
    vim.treesitter.language.register("hcl", "terraform-vars")

    vim.api.nvim_create_autocmd("FileType", {
      callback = function()
        local ok = pcall(vim.treesitter.start)
        if ok then
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}
