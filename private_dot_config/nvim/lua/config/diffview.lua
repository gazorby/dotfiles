local map = vim.keymap.set

require("diffview").setup({ enhanced_diff_hl = true })

map("n", "<leader>gd", "<cmd>DiffviewOpen<cr>", { desc = "[G]it [D]iff" })
map("n", "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", { desc = "[G]it file [H]istory" })
map("n", "<leader>gH", "<cmd>DiffviewFileHistory<cr>", { desc = "[G]it repo [H]istory" })
