if vim.fn.has("gui_running") then
  vim.opt.guifont = "0xProto Nerd Font Mono:h10"
end

local default_clr = "solarized-osaka"
function ColorMyPencils(color)
  color = color or default_clr
  vim.cmd.colorscheme(color)
  vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

-- lazy-nvim requires leader key be setup first
vim.g.mapleader = " "
vim.g.maplocalleader = " "
require("lazy").setup("my-nvim.plugins")

require("my-nvim.remap")
require("my-nvim.setup")
