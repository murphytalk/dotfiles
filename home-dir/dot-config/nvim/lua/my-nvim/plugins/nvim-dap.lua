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
--[[
        dap.adapters.python = function(cb, config)
            if config.request == 'attach' then
                ---@diagnostic disable-next-line: undefined-field
                local port = (config.connect or config).port
                ---@diagnostic disable-next-line: undefined-field
                local host = (config.connect or config).host or '127.0.0.1'
                cb({
                    type = 'server',
                    port = assert(port, '`connect.port` is required for a python `attach` configuration'),
                    host = host,
                    options = {
                        source_filetype = 'python',
                    },
                })
            else
                cb({
                    type = 'executable',
                    command = find_venv() .. '/bin/python',
                    args = { '-m', 'debugpy.adapter' },
                    options = {
                        source_filetype = 'python',
                    },
                })
            end
        end

        vim.keymap.set('n', '<Leader>dc', function ()
            local python = find_venv() .. '/bin/python'
            print('use python at ' .. python)
            dap.configurations.python = {
                {
                    -- The first three options are required by nvim-dap
                    type = 'python'; -- the type here established the link to the adapter definition: `dap.adapters.python`
                    request = 'launch';
                    name = "Launch file";

                    -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

                    program = "${file}"; -- This configuration will launch the current file if used.
                    pythonPath = python
                },
            }
            dap.continue()
        end, {})
]]--
        vim.keymap.set('n', '<Leader>dc', dap.continue, {})
    end
}
