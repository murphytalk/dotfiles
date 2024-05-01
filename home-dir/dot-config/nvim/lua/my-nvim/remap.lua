vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- old emacs habit
vim.api.nvim_set_keymap('n', '<C-x><C-f>', ':edit ', { noremap = true, silent = false })
vim.api.nvim_set_keymap('n', '<C-x>0', ':bd<CR>', { noremap = true, silent = false })
vim.api.nvim_set_keymap('n', '<C-x>1', ':only<CR>', { noremap = true, silent = false })
vim.api.nvim_set_keymap('n', '<C-x>2', ':split<CR>', { noremap = true, silent = false })
vim.api.nvim_set_keymap('n', '<C-x>3', ':vsplit<CR>', { noremap = true, silent = false })

