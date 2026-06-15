vim.opt.statusline = [[
%{&modified ? '[+] ' : ''}%{&readonly ? '[RO] ' : ''}%f
%=
%y %{&fileencoding} %l/%L:%c
]]

vim.opt.showmode = false

-- Minimal buffer winbar (per-window, not full-width tabline)
vim.api.nvim_set_hl(0, "TabLine", { bold = false, reverse = false })
vim.api.nvim_set_hl(0, "TabLineSel", { bold = true, reverse = true })
vim.api.nvim_set_hl(0, "TabLineFill", {})
vim.o.showtabline = 0
function _G.winbar_buffers()
  local cur = vim.api.nvim_get_current_buf()
  local names = {}
  local bufs = {}
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[b].buflisted then
      local full = vim.api.nvim_buf_get_name(b)
      local tail = vim.fn.fnamemodify(full, ":t")
      if tail == "" then tail = "[No Name]" end
      names[tail] = (names[tail] or 0) + 1
      bufs[#bufs + 1] = { buf = b, full = full, tail = tail }
    end
  end
  local items = {}
  for _, v in ipairs(bufs) do
    local label
    if names[v.tail] > 1 then
      local dir = vim.fn.fnamemodify(v.full, ":h:t")
      label = dir ~= "" and (dir .. "/" .. v.tail) or v.tail
    else
      label = v.tail
    end
    local ok, icon = pcall(require("nvim-web-devicons").get_icon, label, vim.bo[v.buf].filetype)
    if ok and icon then label = icon .. " " .. label end
    table.insert(items, ("%%#%s# %s "):format(v.buf == cur and "TabLineSel" or "TabLine", label))
  end
  return table.concat(items)
end

-- Apply winbar to normal editor windows
vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
  callback = function()
    if vim.bo.buftype == "" and vim.bo.buflisted then
      vim.wo.winbar = "%!v:lua.winbar_buffers()"
    end
  end,
})
