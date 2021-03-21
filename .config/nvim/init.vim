call plug#begin(stdpath('data') . '/vim-plug')
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-compe'
Plug 'tpope/vim-commentary'
Plug 'tweekmonster/startuptime.vim'

Plug 'mhartington/oceanic-next'
Plug 'sainnhe/sonokai'
Plug 'romgrk/barbar.nvim'
Plug 'szykol/statusline.nvim'
Plug 'mhinz/vim-signify'
Plug 'tpope/vim-fugitive'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'puremourning/vimspector'
Plug 'szw/vim-maximizer'

Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
call plug#end()

filetype plugin indent on
set cc=120
set ts=4 sw=4 sts=4 et list
set lcs=trail:.,tab:>-
set hid nowrap spr sb ic scs nu rnu tgc nosmd swb=useopen scl=yes nosc noru icm=split
set udir=$HOME/.local/share/nvim/undodir udf
set cot=menuone,noinsert,noselect shm+=c
set bg=dark
set updatetime=500
set scrolloff=8
set termguicolors
set mouse=a
set nohlsearch
set completeopt=menuone,noselect

let &stl = " %f %m"
let g:gruvbox_italicize_strings = 1
let g:gruvbox_contrast_dark = 'hard'
let g:edge_style = 'neon'

colo sonokai

let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']
let g:python3_host_prog = '/usr/bin/python3'

if argv(0) ==# '.'
    let g:netrw_browse_split = 0
else
    let g:netrw_browse_split = 4
endif
let g:netrw_banner = 0
let g:netrw_winsize = 25

let bufferline = get(g:, 'bufferline', {})
let bufferline.icons = v:false
let bufferline.animation = v:false
let bufferline.closable = v:false

let g:signify_sign_change = '│'
let g:signify_sign_add = '│'
let g:signify_sign_delete = '│'
let g:signify_priority = 5

command! Format execute 'lua vim.lsp.buf.formatting()'

luafile ~/.config/nvim/lua/plugins.lua

let mapleader = " "
nn <silent> <leader>n :noh<CR>
tno <silent> <Esc> <C-\><C-n>
nn <silent> <leader>sj :lua vim.lsp.diagnostic.goto_next()<CR>
nn <silent> <leader>sk :lua vim.lsp.diagnostic.goto_prev()<CR>

noremap <C-c> <c-[>
nnoremap <silent> <leader>F <cmd>Telescope find_files<cr>
nnoremap <silent> <leader>f <cmd>Telescope git_files<cr>
nnoremap <silent> <leader>rg <cmd>Telescope grep_string<cr>
nnoremap <silent> <leader>b <cmd>Telescope buffers<cr>
nnoremap <silent> <leader>y <cmd>Telescope help_tags<cr>

nnoremap <silent> <leader>e :bn<CR>
nnoremap <silent> <leader>q :bp<CR>
nnoremap <silent> <leader>w :bd<CR>
nnoremap <silent> <leader>gs :Gstatus<CR>
nnoremap <silent> <leader>gc :Git commit<CR>
nnoremap <silent> <leader>gj <plug>(signify-next-hunk)
nnoremap <silent> <leader>gk <plug>(signify-prev-hunk)
nnoremap <silent> <leader>m :MaximizerToggle!<CR>
nnoremap <silent> <leader>dd :call vimspector#Launch()<CR>

nmap <silent> <leader>dl <Plug>VimspectorStepInto
nmap <silent> <leader>dj <Plug>VimspectorStepOver
nmap <silent> <leader>dk <Plug>VimspectorStepOut
nmap <silent> <leader>d_ <Plug>VimspectorRestart
nmap <silent> <leader>dbp <Plug>VimspectorToggleBreakpoint
nmap <silent> <leader>de <Plug>VimspectorReset
nnoremap <silent> <leader>dg :call vimspector#Continue()<CR>

vnoremap <leader>p "_dP

nnoremap <silent> <leader>h :wincmd h<CR>
nnoremap <silent> <leader>l :wincmd l<CR>
nnoremap <silent> <leader>j :wincmd j<CR>
nnoremap <silent> <leader>k :wincmd k<CR>

inoremap <expr> <C-j> "\<C-n>"
inoremap <expr> <C-k> "\<C-p>"

nnoremap <silent> <leader>t :Lex <bar> :vertical resize 30<CR>
nnoremap <silent> <leader>T :sp<bar>term<CR> :resize 7<CR>
nnoremap <silent> <leader>+ :vertical resize +5<CR>
nnoremap <silent> <leader>- :vertical resize -5<CR>

inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <CR>      compe#confirm('<CR>')
inoremap <silent><expr> <C-e>     compe#close('<C-e>')

fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun

augroup SZYKOL
    autocmd!
    autocmd BufWritePost *.tex :TexlabBuild
    " autocmd BufWritePre * :call TrimWhitespace()
    autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank()
augroup END
