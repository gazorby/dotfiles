local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.scrolloff = 8

opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true
opt.breakindent = true

opt.ignorecase = true
opt.smartcase = true
opt.inccommand = "split"

opt.splitright = true
opt.splitbelow = true

opt.undofile = true
opt.updatetime = 250
opt.confirm = true

opt.list = true
opt.listchars = { tab = "» ", trail = "•", nbsp = "␣", extends = "»", precedes = "«" }
