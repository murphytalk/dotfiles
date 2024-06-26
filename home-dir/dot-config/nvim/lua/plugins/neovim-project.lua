local prj = {}
if vim.loop.os_uname().sysname == "Linux" then
  prj = require("my-nvim.linux-projects")
else
  prj = require("my-nvim.win-projects")
end
return {
  "coffebar/neovim-project",
  cond = not vim.g.vscode,
  opts = {
    projects = prj,
  },
  init = function()
    -- enable saving the state of plugins in the session
    vim.opt.sessionoptions:append("globals") -- save global variables that start with an uppercase letter and contain at least one lowercase letter.
  end,
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    { "nvim-telescope/telescope.nvim", tag = "0.1.4" },
    { "Shatur/neovim-session-manager" },
  },
  lazy = false,
  priority = 100,
}
