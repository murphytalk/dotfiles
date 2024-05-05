return {
  {
    "craftzdog/solarized-osaka.nvim",
    cond = not vim.g.vscode,
    name = "solarized-osaka",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      vim.cmd.colorscheme("solarized-osaka")
    end,
  },
  {
    "olimorris/onedarkpro.nvim",
    lazy = true,
    name = "onedark",
  },
}