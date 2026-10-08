local fzf = require("fzf-lua")
local map = vim.keymap.set

vim.lsp.enable({ "ty", "ruff", "lua_ls", "tombi", "yamlls", "jsonls", "vtsls" })

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    map("n", "gd", fzf.lsp_definitions, { buffer = args.buf, desc = "Goto Definition" })
    map("n", "gD", vim.lsp.buf.declaration, { buffer = args.buf, desc = "Goto Declaration" })
  end,
})

-- fzf pickers on the built-in gr* keys
map("n", "grr", fzf.lsp_references, { desc = "References" })
map("n", "gri", fzf.lsp_implementations, { desc = "Implementations" })
map("n", "grt", fzf.lsp_typedefs, { desc = "Type Definition" })
map("n", "go", fzf.lsp_document_symbols, { desc = "Document Symbols" })
