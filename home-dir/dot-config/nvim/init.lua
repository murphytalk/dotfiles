-- Check if ~/.vimrc exists
if vim.fn.filereadable(vim.fn.expand("~/.vimrc")) == 1 then
  -- Load legacy vimrc using :source command
  vim.cmd("source ~/.vimrc")
end

if vim.loop.os_uname().sysname == "Linux" then
  -- load gentoo syntax
  vim.opt.rtp:append("/usr/share/vim/vimfiles")
end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- lazy-nvim requires leader key be setup first
vim.g.mapleader = " "
vim.g.maplocalleader = " "
require("lazy").setup("plugins")

-- shared options
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

-- Neovim configuration
if vim.g.vscode then
  require("my-vscode")
else
  require("my-nvim")
end
