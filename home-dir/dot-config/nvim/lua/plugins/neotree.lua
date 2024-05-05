return {
  "nvim-neo-tree/neo-tree.nvim",
  cond = not vim.g.vscode,
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
    -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
  },
  config = function()
    require("neo-tree").setup()
    vim.api.nvim_set_keymap("n", "<leader>t", ":Neotree toggle<CR>", { noremap = true, silent = true })
  end,
}
