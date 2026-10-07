require('blink.cmp').setup({
  completion = {
    trigger = { prefetch_on_insert = true, show_on_backspace_in_keyword = true },
    menu = { draw = { treesitter = { 'lsp' } } },
    documentation = { auto_show = true, auto_show_delay_ms = 200 },
    ghost_text = { enabled = true },
  },
  signature = { enabled = true, window = { show_documentation = false } },
  fuzzy = { implementation = 'rust' },
})
