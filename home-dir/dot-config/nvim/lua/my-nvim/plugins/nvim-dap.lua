local function find_venv()
    -- Get the full path of the current file
    local file_path = vim.fn.expand('%:p')
    -- Get the directory containing the file
    local dir_path = vim.fn.fnamemodify(file_path, ':h')

    while dir_path ~= '/' do
        -- Check if `v` or `venv` directory exists
        if vim.fn.isdirectory(dir_path .. '/v') == 1 then
            return dir_path .. '/v'
        elseif vim.fn.isdirectory(dir_path .. '/venv') == 1 then
            return dir_path .. '/venv'
        end
        -- Move up one level
        dir_path = vim.fn.fnamemodify(dir_path, ':h')
    end

    -- If not found, resolve to a fixed path
    return '/usr'
end

return {
    'mfussenegger/nvim-dap',
    dependencies = {
        "rcarriga/nvim-dap-ui",
        "nvim-neotest/nvim-nio",
        "mfussenegger/nvim-dap-python",
    },
    config = function()
        local dap, dapui = require("dap"), require("dapui")
        dapui.setup()
        dap.listeners.before.attach.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.launch.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.event_terminated.dapui_config = function()
            dapui.close()
        end
        dap.listeners.before.event_exited.dapui_config = function()
            dapui.close()
        end

        local dap_python = require('dap-python')
        local py = find_venv() .. '/bin/python'
        local pydbg = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
        dap_python.setup(pydbg)
        dap_python.resolve_python = function()
            return py
        end
        vim.keymap.set('n', '<Leader>dt', dap.toggle_breakpoint, {})
        vim.keymap.set('n', '<Leader>dc', dap.continue, {})
    end
}
