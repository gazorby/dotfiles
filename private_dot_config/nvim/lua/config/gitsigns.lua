local gitsigns = require("gitsigns")
local map = vim.keymap.set

gitsigns.setup()

map("n", "]c", function()
  if vim.wo.diff then vim.cmd.normal({ "]c", bang = true }) else gitsigns.nav_hunk("next") end
end, { desc = "Next hunk" })
map("n", "[c", function()
  if vim.wo.diff then vim.cmd.normal({ "[c", bang = true }) else gitsigns.nav_hunk("prev") end
end, { desc = "Prev hunk" })
map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "[H]unk [S]tage" })
map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "[H]unk [R]eset" })
map("n", "<leader>hp", gitsigns.preview_hunk_inline, { desc = "[H]unk [P]review" })
map("n", "<leader>hb", gitsigns.blame_line, { desc = "[H]unk [B]lame line" })
map({ "o", "x" }, "ih", gitsigns.select_hunk, { desc = "Inner hunk" })
