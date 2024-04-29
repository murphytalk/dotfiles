return {
    'yorickpeterse/nvim-window',
    config = function()
        local w = require('nvim-window')
        vim.keymap.set('n', '<leader>w', w.pick, {})
    end
}
