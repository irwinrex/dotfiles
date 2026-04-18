-- Filetype detection for Jenkinsfile/Groovy
return {
  {
    "nvim-lua/plenary.nvim",
    lazy = true,
    init = function()
      vim.filetype.add({
        filename = {
          ["Jenkinsfile"] = "groovy",
        },
        pattern = {
          [".*Jenkinsfile.+"] = "groovy",
          [".*%.jenkinsfile"] = "groovy",
          [".*/(alpha|beta|prod|staging|demo|dev|uat)$"] = {
            priority = 10,
            function(_, bufnr)
              if not vim.api.nvim_buf_is_loaded(bufnr) then
                return nil
              end
              local lines = vim.api.nvim_buf_get_lines(bufnr, 0, 20, false)
              for _, line in ipairs(lines) do
                local trimmed = line:match("^%s*(.-)%s*$")
                if trimmed ~= "" then
                  if trimmed:match("^pipeline%s*{") or trimmed:match("^node%s*[({]") then
                    return "groovy"
                  end
                  return nil
                end
              end
            end,
          },
        },
      })
    end,
  },
}
