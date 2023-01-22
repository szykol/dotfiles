local statuscolumn = require "szykol.statuscolumn"
local opt = vim.opt
local home = vim.fn.expand('$HOME')

opt.colorcolumn = "120"
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true
opt.list = true
opt.listchars = {
    tab = "» ",
    trail = "."
}
opt.hidden = true
opt.wrap = false
opt.splitright = true
opt.splitbelow = true
opt.ignorecase = true
opt.smartcase = true
opt.number = true
opt.relativenumber = true
opt.termguicolors = true
opt.showmode = false
opt.switchbuf = "useopen"
opt.signcolumn = "yes"
opt.showcmd = false
opt.ruler = false
opt.inccommand = "split"
opt.undodir = home .. "/.local/share/nvim/undodir"
opt.undofile = true
opt.shortmess:append "c"
opt.background = "dark"
opt.updatetime = 500
opt.scrolloff = 8
opt.termguicolors = true
opt.mouse = "a"
opt.hlsearch = false
opt.completeopt = "menu,menuone,noselect"
opt.clipboard:append "unnamedplus"
opt.equalalways = false
opt.guifont = "UbuntuMono NF:h9"
opt.pumheight = 10
opt.laststatus = 3
opt.wrap = true

statuscolumn.set_global_statuscolumn()
