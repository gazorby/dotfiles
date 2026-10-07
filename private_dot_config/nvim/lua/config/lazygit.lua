local map = vim.keymap.set

map("n", "<leader>gg", "<cmd>LazyGit<cr>", { desc = "Lazygit" })
map("n", "<leader>gl", "<cmd>LazyGitLog<cr>", { desc = "[G]it [L]og" })
map("n", "<leader>gf", "<cmd>LazyGitFilterCurrentFile<cr>", { desc = "[G]it [F]ile log" })
