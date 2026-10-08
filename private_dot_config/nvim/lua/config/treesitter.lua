local languages = { 'python', 'lua', 'toml', 'yaml', 'json', 'javascript', 'typescript', 'tsx' }

require('nvim-treesitter').install(languages)

vim.api.nvim_create_autocmd('FileType', {
  pattern = vim.list_extend({ 'javascriptreact', 'typescriptreact' }, languages),
  callback = function() vim.treesitter.start() end,
})
