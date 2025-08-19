return {
    "Joakker/todo-txt.nvim",
    ft = { "todo", "todotxt" }, -- Or ft = { "todo.txt" }
    config = function()
        require("todo-txt").setup({
            -- You can add custom configuration here if needed
            -- For example, to enable sorting on save:
            -- sort_on_write = true, 
        })
    end,
    dependencies = {
        "nvim-lua/plenary.nvim",
        -- Optional, for fuzzy finding tasks:
        -- "nvim-telescope/telescope.nvim",
    },
}
