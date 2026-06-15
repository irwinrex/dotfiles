vim.opt.statusline = [[
%{&modified ? '[+] ' : ''}%{&readonly ? '[RO] ' : ''}%f
%=
%y %{&fileencoding} %l/%L:%c
]]

vim.opt.showmode = false
