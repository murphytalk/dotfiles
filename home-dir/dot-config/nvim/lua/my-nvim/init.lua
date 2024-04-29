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


local default_clr='solarized-osaka'
function ColorMyPencils(color)
    color = color or default_clr
    vim.cmd.colorscheme(color)
    vim.api.nvim_set_hl(0,"Normal",{bg = "none"})
    vim.api.nvim_set_hl(0,"NormalFloat",{bg = "none"})
end


-- lazy-nvim requires leader key be setup first
vim.g.mapleader = " "
vim.g.maplocalleader = " "
require("lazy").setup("my-nvim.plugins")

require("my-nvim.remap")
require("my-nvim.setup")
