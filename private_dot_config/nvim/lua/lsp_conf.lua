local fzf = require("fzf-lua")
local map = vim.keymap.set

vim.lsp.enable({ "ty", "ruff", "lua_ls" })

-- fzf pickers on the built-in gr*/gO keys
map("n", "gd", fzf.lsp_definitions, { desc = "Goto Definition" })
map("n", "gD", vim.lsp.buf.declaration, { desc = "Goto Declaration" })
map("n", "grr", fzf.lsp_references, { desc = "References" })
map("n", "gri", fzf.lsp_implementations, { desc = "Implementations" })
map("n", "grt", fzf.lsp_typedefs, { desc = "Type Definition" })
map("n", "gO", fzf.lsp_document_symbols, { desc = "Document Symbols" })
