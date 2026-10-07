vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local data = ev.data
    if data.spec.name == 'nvim-treesitter' and data.kind == 'update' then
      if not data.active then vim.cmd.packadd('nvim-treesitter') end
      vim.cmd('TSUpdate')
    end
  end,
})

vim.pack.add({
  { src = 'https://github.com/dlyongemallo/diffview-plus.nvim' },
  { src = 'https://github.com/ibhagwan/fzf-lua' },
  { src = 'https://github.com/kdheepak/lazygit.nvim' },
  { src = 'https://github.com/lewis6991/gitsigns.nvim' },
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter' },
  { src = 'https://github.com/loctvl842/monokai-pro.nvim' },
  { src = 'https://github.com/saghen/blink.lib' },
  { src = 'https://github.com/saghen/blink.pairs', version = vim.version.range('*') },
  { src = 'https://github.com/rafamadriz/friendly-snippets' },
  { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range('1.*') },
  { src = 'https://github.com/nvim-tree/nvim-web-devicons' },
  { src = 'https://github.com/nvim-lualine/lualine.nvim' },
  { src = 'https://github.com/neovim/nvim-lspconfig' },
  { src = 'https://github.com/linux-cultist/venv-selector.nvim' },
  { src = 'https://github.com/lukas-reineke/indent-blankline.nvim' },
  { src = 'https://github.com/MeanderingProgrammer/render-markdown.nvim' },
})

require("config.fzf-lua")
require("config.venv-selector")
require("config.treesitter")
require("config.indent-blankline")
require("config.blink-pairs")
require("config.blink-cmp")
require("config.diffview")
require("config.lazygit")
require("config.gitsigns")
require("config.lualine")
require("config.render-markdown")
