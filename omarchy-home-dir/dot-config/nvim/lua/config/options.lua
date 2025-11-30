-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.relativenumber = true

-- in lua/config/options.lua or similar
vim.opt.fillchars = { vert = "┃", horiz = "━" }
vim.cmd([[
  highlight WinSeparator guibg=None guifg=#00FF00
]])
