return {
  "yorickpeterse/nvim-window",
  cond = not vim.g.vscode,
  config = function()
    local w = require("nvim-window")
    vim.keymap.set("n", "<leader>W", w.pick, {})
  end,
}
