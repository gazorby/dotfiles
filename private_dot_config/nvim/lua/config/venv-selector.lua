require("venv-selector").setup({ options = { picker = "fzf-lua" } })
vim.keymap.set("n", "<leader>v", "<cmd>VenvSelect<cr>", { desc = "Select Python [V]env" })
