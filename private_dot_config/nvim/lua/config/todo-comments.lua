local todo = require("todo-comments")
local map = vim.keymap.set

todo.setup({})

map("n", "]t", todo.jump_next, { desc = "Next todo comment" })
map("n", "[t", todo.jump_prev, { desc = "Prev todo comment" })
map("n", "<leader>st", function()
  require("todo-comments.fzf").todo()
end, { desc = "[S]earch [T]odos" })
map("n", "<leader>sT", function()
  require("todo-comments.fzf").todo({ keywords = { "TODO", "FIX", "FIXME" } })
end, { desc = "[S]earch [T]odo/Fix" })
