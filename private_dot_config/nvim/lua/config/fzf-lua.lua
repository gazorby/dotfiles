local fzf = require("fzf-lua")
local map = vim.keymap.set

local guicursor
fzf.setup({
  "fzf-native",
  winopts = {
    on_create = function()
      guicursor = vim.o.guicursor
      vim.o.guicursor = guicursor:gsub("t:[^,]*", "t:block-blinkon0-TermCursor")
    end,
    on_close = function()
      vim.o.guicursor = guicursor
    end,
  },
})

-- Find (by name)
map("n", "<leader><leader>", fzf.buffers, { desc = "Buffers" })
map("n", "<leader>ff", fzf.files, { desc = "[F]ind [F]iles" })
map("n", "<leader>fg", fzf.git_files, { desc = "[F]ind [G]it files" })
map("n", "<leader>fo", fzf.oldfiles, { desc = "[F]ind [O]ld files" })
map("n", "<leader>fc", function()
  fzf.files({ cwd = vim.fn.stdpath("config") })
end, { desc = "[F]ind [C]onfig" })

-- Search (by content)
map("n", "<leader>/", fzf.blines, { desc = "Search buffer lines" })
map("n", "<leader>sg", fzf.live_grep, { desc = "[S]earch [G]rep" })
map("n", "<leader>sw", fzf.grep_cword, { desc = "[S]earch [W]ord" })
map("n", "<leader>sW", fzf.grep_cWORD, { desc = "[S]earch [W]ORD" })
map("v", "<leader>sw", fzf.grep_visual, { desc = "[S]earch selection" })
map("n", "<leader>ss", fzf.lsp_live_workspace_symbols, { desc = "[S]earch [S]ymbols" })
map("n", "<leader>sd", fzf.diagnostics_document, { desc = "[S]earch [D]iagnostics" })
map("n", "<leader>sD", fzf.diagnostics_workspace, { desc = "[S]earch workspace [D]iagnostics" })
map("n", "<leader>sh", fzf.helptags, { desc = "[S]earch [H]elp" })
map("n", "<leader>sk", fzf.keymaps, { desc = "[S]earch [K]eymaps" })
map("n", "<leader>sc", fzf.commands, { desc = "[S]earch [C]ommands" })
map("n", "<leader>s:", fzf.command_history, { desc = "[S]earch command history" })
map("n", "<leader>sq", fzf.quickfix, { desc = "[S]earch [Q]uickfix" })
map("n", "<leader>sr", fzf.resume, { desc = "[S]earch [R]esume" })
map("n", "<leader>sb", fzf.builtin, { desc = "[S]earch [B]uiltin pickers" })

-- Git
map("n", "<leader>gb", fzf.git_branches, { desc = "[G]it [B]ranches" })
map("n", "<leader>gs", fzf.git_status, { desc = "[G]it [S]tatus files" })
map("n", "<leader>gL", fzf.git_bcommits, { desc = "[G]it buffer [L]og" })
