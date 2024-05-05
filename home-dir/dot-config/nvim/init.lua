-- Check if ~/.vimrc exists
if vim.fn.filereadable(vim.fn.expand("~/.vimrc")) == 1 then
  -- Load legacy vimrc using :source command
  vim.cmd("source ~/.vimrc")
end

if vim.loop.os_uname().sysname == "Linux" then
  -- load gentoo syntax
  vim.opt.rtp:append("/usr/share/vim/vimfiles")
end

-- Neovim configuration
require("my-nvim")
