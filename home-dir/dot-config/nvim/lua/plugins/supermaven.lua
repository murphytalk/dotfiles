return {
  "supermaven-inc/supermaven-nvim",
  cond = not vim.g.vscode,
  config = function()
    require("supermaven-nvim").setup({
      ignore_filetypes = { "markdown", "org", "md", "yaml" },
    })
  end,
}
