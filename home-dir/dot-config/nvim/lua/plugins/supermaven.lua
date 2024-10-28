return {
  "supermaven-inc/supermaven-nvim",
  cond = not vim.g.vscode,
  config = function()
    require("supermaven-nvim").setup({})
  end,
}
