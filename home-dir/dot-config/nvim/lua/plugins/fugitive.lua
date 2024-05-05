return {
  "tpope/vim-fugitive",
  cond = not vim.g.vscode,
  config = function()
    vim.keymap.set("n", "<leader>g", vim.cmd.Git)
  end,
}
