return {
  "phrmendes/todotxt.nvim",
  cmd = { "TodoTxt", "DoneTxt" },
  opts = {
    todotxt = "/mnt/d/Syncthing/mobile/todo/todo.txt",
    donetxt = "/mnt/d/Syncthing/mobile/todo/done.txt",
  },
  --  config = function()
  --    vim.keymap.set("n", "<leader>tn", "<cmd>TodoTxt new<cr>", { desc = "New todo entry" })
  --    vim.keymap.set("n", "<leader>tt", "<cmd>TodoTxt<cr>", { desc = "Toggle todo.txt" })
  --    vim.keymap.set("n", "<leader>td", "<cmd>DoneTxt<cr>", { desc = "Toggle done.txt" })
  --    vim.keymap.set("n", "<cr>", "<Plug>(TodoTxtToggleState)", { desc = "Toggle task state" })
  --    vim.keymap.set("n", "<c-c>n", "<Plug>(TodoTxtCyclePriority)", { desc = "Cycle priority" })
  --    vim.keymap.set("n", "<leader>tm", "<Plug>(TodoTxtMoveDone)", { desc = "Move done tasks" })
  --    vim.keymap.set("n", "<leader>tss", "<Plug>(TodoTxtSortTasks)", { desc = "Sort tasks (default)" })
  --    vim.keymap.set("n", "<leader>tsp", "<Plug>(TodoTxtSortByPriority)", { desc = "Sort by priority" })
  --    vim.keymap.set("n", "<leader>tsc", "<Plug>(TodoTxtSortByContext)", { desc = "Sort by context" })
  --    vim.keymap.set("n", "<leader>tsP", "<Plug>(TodoTxtSortByProject)", { desc = "Sort by project" })
  --    vim.keymap.set("n", "<leader>tsd", "<Plug>(TodoTxtSortByDueDate)", { desc = "Sort by due date" })
  --  end,
}
