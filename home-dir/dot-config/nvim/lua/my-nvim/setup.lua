-- relative linue number
vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.updatetime = 50

-- append full path in status
local current_statusline = vim.opt.statusline:get()
vim.opt.statusline = current_statusline .. " %F"

--vim.opt.autochdir = true
--
-- Toggle window zoom in Neovim
local zoomed = false
local winrestcmd = nil

function ToggleZoom()
  if zoomed then
    -- If already zoomed, restore the previous layout
    vim.cmd(winrestcmd)
    zoomed = false
  else
    -- Save the current window layout and maximize the current window
    winrestcmd = vim.fn.winrestcmd()
    vim.cmd('resize')
    vim.cmd('vertical resize')
    zoomed = true
  end
end

-- Key mapping to toggle the zoom
vim.api.nvim_set_keymap('n', '<leader>z', '<cmd>lua ToggleZoom()<CR>', {noremap = true, silent = true})


