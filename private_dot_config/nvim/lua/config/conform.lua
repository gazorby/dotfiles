local conform = require("conform")

conform.setup({
  formatters_by_ft = {
    python = { "ruff_organize_imports", "ruff_format" },
    lua = { "stylua" },
  },
  default_format_opts = { lsp_format = "fallback" },
  format_on_save = function(bufnr)
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      return
    end
    return { timeout_ms = 500 }
  end,
})

vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

vim.api.nvim_create_user_command("FormatToggle", function(args)
  local scope = args.bang and vim.b or vim.g
  scope.disable_autoformat = not scope.disable_autoformat
  vim.notify(
    ("Format on save %s%s"):format(scope.disable_autoformat and "disabled" or "enabled", args.bang and " (buffer)" or "")
  )
end, { bang = true, desc = "Toggle format on save (! for current buffer)" })

vim.keymap.set({ "n", "x" }, "<leader>cf", function()
  conform.format({ async = true })
end, { desc = "[C]ode [F]ormat" })
vim.keymap.set("n", "<leader>cF", "<cmd>FormatToggle<cr>", { desc = "[C]ode toggle [F]ormat on save" })
