local keymap = require("szykol.keymap")

local nnoremap = keymap.nnoremap
local vnoremap = keymap.vnoremap
local xnoremap = keymap.xnoremap
local inoremap = keymap.inoremap
local tnoremap = keymap.tnoremap

local utils = require("utils")

nnoremap("<C-h>", ":wincmd h<CR>")
nnoremap("<C-j>", ":wincmd j<CR>")
nnoremap("<C-l>", ":wincmd l<CR>")
nnoremap("<C-k>", ":wincmd k<CR>")

tnoremap("<Esc>", [[<C-\><C-n>]])
-- tnoremap("<C-[", [[<C-\><C-n>]])
tnoremap("<C-h>", [[<C-\><C-n><C-W>h]])
tnoremap("<C-j>", [[<C-\><C-n><C-W>j]])
tnoremap("<C-l>", [[<C-\><C-n><C-W>l]])
tnoremap("<C-k>", [[<C-\><C-n><C-W>k]])

nnoremap("<leader>+", ":vertical resize +5<CR>")
nnoremap("<leader>-", ":vertical resize -5<CR>")

nnoremap("<leader>T", function() require"utils".open_terminal() end)
nnoremap("<leader>tt", ":term<CR>")

-- Telescope
nnoremap("<leader>t",   "<CMD>Telescope<CR>")
nnoremap("<leader>tF",  "<CMD>Telescope find_files theme=ivy<CR>")
nnoremap("<leader>tc",  "<CMD>Telescope find_files cwd=$HOME/.config/nvim theme=ivy<CR>")
nnoremap("<leader>tf",  "<CMD>Telescope git_files theme=ivy<CR>")
nnoremap("<leader>tr",  "<CMD>Telescope live_grep theme=ivy<CR>")
nnoremap("<leader>tb",  "<CMD>Telescope buffers theme=ivy<CR>")
nnoremap("<leader>th",  "<CMD>Telescope help_tags theme=ivy<CR>")
nnoremap("<leader>tg",  "<CMD>Telescope git_branches theme=ivy<CR>")
nnoremap("<leader>P",   "<CMD>Telescope command_center<CR>")
nnoremap("<leader>tws",  function() require('telescope').extensions.git_worktree.git_worktrees() end)
nnoremap("<leader>twc",  function() require('telescope').extensions.git_worktree.create_git_worktree() end)
nnoremap("<leader>m", ":MaximizerToggle!<CR>")
nnoremap("<leader>v", ":vsplit<CR>")
nnoremap("<leader>s", ":split<CR>")
nnoremap("<leader>S", ":bot split<CR>:resize 10<CR>")

nnoremap("<leader>dl", function() require"dap".step_into() end)
nnoremap("<leader>dj", function() require"dap".step_over() end)
nnoremap("<leader>dk", function() require"dap".step_out() end)
nnoremap("<leader>dg", function() require"dap".continue() end)
nnoremap("<leader>db", function() require"dap".toggle_breakpoint() end)
nnoremap("<leader>dt", function() require"dapui".toggle() end)

nnoremap("<leader>nt", ":NvimTreeToggle<CR>")
nnoremap("<leader>nr", ":NvimTreeRefresh<CR>")
nnoremap("<leader>nf", ":NvimTreeFindFile<CR>")
vnoremap("<leader>rr", ":<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>")

nnoremap("<leader>gj", ":Gitsigns next_hunk<CR>")
nnoremap("<leader>gk", ":Gitsigns prev_hunk<CR>")
