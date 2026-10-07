require('nvim-treesitter').install({ 'python', 'lua' })

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'python', 'lua' },
  callback = function() vim.treesitter.start() end,
})
