vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.api.nvim_set_keymap("n", "<C-p>", ":Telescope neovim-project discover<CR>", { noremap = true, silent = false })
-- for some reason the buffer sometimes loses line number display, especially when using terminal
vim.api.nvim_set_keymap("n", "<leader>N", ":setlocal relativenumber<CR>", { noremap = true, silent = false })

-- Function to map <Esc> to <C-\><C-n> in terminal mode
vim.api.nvim_set_keymap("t", "<Esc>", "<C-\\><C-n>", { noremap = true, silent = true })

-- old emacs habit
vim.api.nvim_set_keymap("n", "<C-x><C-f>", ":edit ", { noremap = true, silent = false })
vim.api.nvim_set_keymap("n", "<C-x>0", ":bd<CR>", { noremap = true, silent = false })
vim.api.nvim_set_keymap("n", "<C-x>1", ":only<CR>", { noremap = true, silent = false })
vim.api.nvim_set_keymap("n", "<C-x>2", ":split<CR>", { noremap = true, silent = false })
vim.api.nvim_set_keymap("n", "<C-x>3", ":vsplit<CR>", { noremap = true, silent = false })

if vim.g.neovide == true then
  vim.api.nvim_set_keymap("n", "<F11>", ":let g:neovide_fullscreen = !g:neovide_fullscreen<CR>", {})
end
