vim.opt.statusline = table.concat({
  "%#StatusLineAccent# %{&modified ? ' ●' : '  '} %f ",
  "%#StatusLine#%{&readonly ? '  ' : ''}",
  "%=",
  "%#StatusLineMuted# %y  %{&fileencoding !=# '' ? &fileencoding : &encoding} ",
  "%#StatusLineAccent# %l:%c  %p%% ",
})

vim.opt.showmode = false
