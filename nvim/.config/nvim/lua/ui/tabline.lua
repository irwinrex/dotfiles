local M = {}
local icon_highlight_cache = {}

local function is_pinned(buf)
  return vim.api.nvim_buf_is_valid(buf) and vim.b[buf].snacks_pinned == true
end

local function listed_buffers()
  local buffers = {}
  for order, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted then
      buffers[#buffers + 1] = { buf = buf, order = order, pinned = is_pinned(buf) }
    end
  end
  table.sort(buffers, function(a, b)
    if a.pinned ~= b.pinned then
      return a.pinned
    end
    return a.order < b.order
  end)
  return buffers
end

local function icon_for(name)
  if not rawget(_G, "Snacks") then
    return "󰈔", nil
  end
  local icon, highlight = Snacks.util.icon(name, "file")
  return icon:gsub("%s+$", ""), highlight
end

local function tab_icon_highlight(source_name, selected)
  local key = (source_name or "Default") .. (selected and ":selected" or ":normal")
  if icon_highlight_cache[key] then
    return icon_highlight_cache[key]
  end

  local tab_name = selected and "TabLineSel" or "TabLine"
  local tab_highlight = vim.api.nvim_get_hl(0, { name = tab_name, link = false })
  local icon_highlight = {}
  if source_name then
    local ok, highlight = pcall(vim.api.nvim_get_hl, 0, { name = source_name, link = false })
    if ok then
      icon_highlight = highlight
    end
  end

  local target_name = "BufferTabIcon_" .. (source_name or "Default") .. (selected and "Sel" or "")
  vim.api.nvim_set_hl(0, target_name, {
    fg = icon_highlight.fg or tab_highlight.fg,
    bg = tab_highlight.bg,
    bold = false,
  })
  icon_highlight_cache[key] = target_name
  return target_name
end

local function display_names(buffers)
  local counts = {}
  local names = {}
  for _, entry in ipairs(buffers) do
    local path = vim.api.nvim_buf_get_name(entry.buf)
    local name = path == "" and "[No Name]" or vim.fn.fnamemodify(path, ":t")
    names[entry.buf] = name
    counts[name] = (counts[name] or 0) + 1
  end

  for _, entry in ipairs(buffers) do
    local path = vim.api.nvim_buf_get_name(entry.buf)
    local name = names[entry.buf]
    if path ~= "" and counts[name] > 1 then
      name = vim.fn.fnamemodify(path, ":h:t") .. "/" .. name
    end
    if vim.fn.strdisplaywidth(name) > 24 then
      name = vim.fn.strcharpart(name, 0, 21) .. "…"
    end
    names[entry.buf] = name:gsub("%%", "%%%%"):gsub("[\r\n]", " ")
  end
  return names
end

local function close_buffer(buf)
  if not vim.api.nvim_buf_is_valid(buf) then
    return
  end
  if rawget(_G, "Snacks") then
    Snacks.bufdelete.delete(buf)
  else
    vim.api.nvim_buf_delete(buf, { force = false })
  end
  vim.cmd.redrawtabline()
end

function M.render()
  local buffers = listed_buffers()
  local names = display_names(buffers)
  local current = vim.api.nvim_get_current_buf()
  local parts = {}

  for index, entry in ipairs(buffers) do
    local buf = entry.buf
    local selected = buf == current
    local base_hl = selected and "%#TabLineSel#" or "%#TabLine#"
    local pin_hl = selected and "%#BufferTabPinnedSel#" or "%#BufferTabPinned#"
    local error_hl = selected and "%#BufferTabDiagnosticErrorSel#" or "%#BufferTabDiagnosticError#"
    local warn_hl = selected and "%#BufferTabDiagnosticWarnSel#" or "%#BufferTabDiagnosticWarn#"
    local diagnostics = vim.diagnostic.count(buf)
    local errors = diagnostics[vim.diagnostic.severity.ERROR] or 0
    local warnings = diagnostics[vim.diagnostic.severity.WARN] or 0
    local modified = vim.bo[buf].modified and " ●" or ""
    local icon, icon_source_hl = icon_for(names[buf])
    local icon_hl = tab_icon_highlight(icon_source_hl, selected)

    parts[#parts + 1] = base_hl
    parts[#parts + 1] = ("%%%d@v:lua.DotfilesTablineSelect@"):format(buf)
    parts[#parts + 1] = (" %d "):format(index)
    if entry.pinned then
      parts[#parts + 1] = pin_hl .. " " .. base_hl
    end
    parts[#parts + 1] = ("%%#%s#%s"):format(icon_hl, icon)
    parts[#parts + 1] = base_hl .. " " .. names[buf] .. modified
    if errors > 0 then
      parts[#parts + 1] = error_hl .. (" %d"):format(errors) .. base_hl
    end
    if warnings > 0 then
      parts[#parts + 1] = warn_hl .. (" %d"):format(warnings) .. base_hl
    end
    parts[#parts + 1] = "%T"
    parts[#parts + 1] = ("%%%d@v:lua.DotfilesTablineClose@ 󰅖 %%T"):format(buf)
    parts[#parts + 1] = "%#TabLineFill#│"
  end

  parts[#parts + 1] = "%#TabLineFill#%T"
  return table.concat(parts)
end

_G.DotfilesTabline = M.render
_G.DotfilesTablineSelect = function(buf, _, button)
  if button == "m" then
    close_buffer(buf)
  elseif button == "l" and vim.api.nvim_buf_is_valid(buf) then
    vim.api.nvim_set_current_buf(buf)
  end
end
_G.DotfilesTablineClose = function(buf, _, button)
  if button == "l" or button == "m" then
    close_buffer(buf)
  end
end

vim.opt.showtabline = 2
vim.opt.tabline = "%!v:lua.DotfilesTabline()"

local icon_highlight_group = vim.api.nvim_create_augroup("DotfilesTablineIcons", { clear = true })
vim.api.nvim_create_autocmd("ColorScheme", {
  group = icon_highlight_group,
  callback = function()
    icon_highlight_cache = {}
  end,
})

return M
