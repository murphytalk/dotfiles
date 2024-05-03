return {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.6',
    -- or                              , branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
        vim.keymap.set('n', '<leader>fG', builtin.git_files, {})
        vim.keymap.set('n', '<leader>f.', builtin.oldfiles, {})
        vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
        vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
        vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
        vim.keymap.set('n', '<leader>fd', builtin.diagnostics, {})
        vim.keymap.set('n', '<leader>ps', function()
            -- needs to install ripgrep
            builtin.grep_string({ search = vim.fn.input("Grep > ")})
        end)
    end
}
