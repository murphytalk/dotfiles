return {
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      -- The list of servers to install from mason.
      servers = {
        jinja_lsp = {},
      },
      -- 诊断显示: ERROR 红色 inline 始终显示, WARN/HINT 只在光标行浮窗显示
      diagnostics = {
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "icons",
          -- 只 inline 显示 ERROR，WARN/HINT 不占行末
          severity = { min = vim.diagnostic.severity.ERROR },
        },
        -- 光标所在行的所有诊断通过浮窗显示
        float = {
          source = "if_many",
          header = "",
          prefix = "",
          focusable = false,
          scope = "line",          -- cursor=精确位置, line=整行
          border = "rounded",
        },
      },
    },
  },
}
