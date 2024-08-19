-- relative linue number
vim.opt.nu = true
vim.opt.relativenumber = true
vim.wo.relativenumber = true

vim.opt.swapfile = false
vim.opt.backup = false
if vim.loop.os_uname().sysname == "Linux" then
  vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
end
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.updatetime = 50
vim.opt.timeoutlen = 200
-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
-- append full path in status

local current_statusline = vim.opt.statusline:get()
vim.opt.statusline = current_statusline .. " %F"

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking text",
  -- group to avoid duplicated listeners
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- https://github.com/epwalsh/obsidian.nvim/issues/286
vim.opt_local.conceallevel = 2
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
    vim.cmd("resize")
    vim.cmd("vertical resize")
    zoomed = true
  end
end

-- Key mapping to toggle the zoom
vim.api.nvim_set_keymap("n", "<leader>z", "<cmd>lua ToggleZoom()<CR>", { noremap = true, silent = true })
