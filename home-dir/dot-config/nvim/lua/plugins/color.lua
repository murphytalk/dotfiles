return {
  {
    "folke/tokyonight.nvim",
    cond = not vim.g.vscode,
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
      vim.cmd.colorscheme("tokyonight")
    end,
  },
  {
    "craftzdog/solarized-osaka.nvim",
    cond = not vim.g.vscode,
    name = "solarized-osaka",
    lazy = true,
  },
  {
    "olimorris/onedarkpro.nvim",
    lazy = true,
    cond = not vim.g.vscode,
    name = "onedark",
  },
}
