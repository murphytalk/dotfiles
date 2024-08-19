return {
  {
    "folke/tokyonight.nvim",
    cond = not vim.g.vscode,
    lazy = false,
    priority = 1000,
    opts = {},
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
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("catppuccin-mocha")
    end,
  },
}
