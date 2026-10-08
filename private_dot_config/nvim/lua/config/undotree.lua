vim.cmd.packadd("nvim.undotree")

vim.keymap.set("n", "<leader>u", function() require("undotree").open() end, { desc = "[U]ndotree" })
