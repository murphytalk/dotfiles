-- Check if ~/.vimrc exists
if vim.fn.filereadable(vim.fn.expand("~/.vimrc")) == 1 then
    -- Load legacy vimrc using :source command
    vim.cmd("source ~/.vimrc")
end

-- load gentoo syntax
vim.opt.rtp:append('/usr/share/vim/vimfiles')

-- Neovim configuration
require("my-nvim")

--print("nvim bootstrapped from lua confg!")