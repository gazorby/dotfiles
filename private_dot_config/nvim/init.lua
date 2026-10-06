vim.pack.add({
  'https://github.com/tpope/vim-sensible',
  'https://github.com/dlyongemallo/diffview-plus.nvim',
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/nvim-telescope/telescope-fzf-native.nvim',
  { src = 'https://github.com/nvim-telescope/telescope.nvim', version = vim.version.range('*') },
  'https://github.com/NeogitOrg/neogit',
  'https://github.com/lewis6991/gitsigns.nvim',
  'https://github.com/nvim-treesitter/nvim-treesitter',
  'https://github.com/loctvl842/monokai-pro.nvim',
})

vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local data = ev.data
    if data.spec.name == 'telescope-fzf-native.nvim' and data.kind ~= 'delete' then
      vim.system({ 'make' }, { cwd = data.path }):wait()
    end
    if data.spec.name == 'nvim-treesitter' and data.kind == 'update' then
      vim.cmd('TSUpdate')
    end
  end,
})

-- Colorscheme
require("monokai-pro").setup()
vim.cmd.colorscheme("monokai-pro")

-- treesitter
require('nvim-treesitter').setup {
  -- Directory to install parsers and queries to (prepended to `runtimepath` to have priority)
  install_dir = vim.fn.stdpath('data') .. '/site'
}
require('nvim-treesitter').install { 'python', 'lua' }

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'python', 'lua' },
  callback = function()
    vim.treesitter.start()
  end,
})

-- telescope
local builtin = require('telescope.builtin')
require('telescope').load_extension('fzf')

vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

-- diffview
require("diffview").setup({
  enhanced_diff_hl = true,
  use_icons = true,
  view = {
    default = { layout = "diff2_horizontal" },
    merge_tool = { layout = "diff3_horizontal" },
  },
  file_panel = {
    listing_style = "tree",
    win_config = { position = "left", width = 35 }, -- Use "auto" to fit content
  },
  hooks = {},   -- See :h diffview-config-hooks
  keymaps = {}, -- See :h diffview-config-keymaps
})

-- neogit
local neogit = require("neogit")
vim.keymap.set("n", "<leader>gg", "<cmd>Neogit<cr>", { desc = "Open Neogit UI" })
