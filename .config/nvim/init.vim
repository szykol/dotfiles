function! Cond(cond, ...)
  let opts = get(a:000, 0, {})
  return a:cond ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction

call plug#begin(stdpath('data') . '/vim-plug')

Plug 'tpope/vim-commentary'
Plug 'asvetliakov/vim-easymotion', Cond(exists('g:vscode'), { 'as': 'vsc-easymotion' }) 
if !exists('g:vscode')
    Plug 'neovim/nvim-lspconfig'
    Plug 'hrsh7th/nvim-compe'
    Plug 'tweekmonster/startuptime.vim'
    Plug 'mhartington/oceanic-next'
    Plug 'sainnhe/sonokai'
    Plug 'pineapplegiant/spaceduck', { 'branch': 'main' }

    Plug 'romgrk/barbar.nvim'
    Plug 'mhinz/vim-signify'
    Plug 'tpope/vim-fugitive'
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'puremourning/vimspector'
    Plug 'szw/vim-maximizer'
    Plug 'kyazdani42/nvim-web-devicons'
    Plug 'glepnir/galaxyline.nvim'
    Plug 'monsonjeremy/onedark.nvim'

    Plug 'nvim-lua/popup.nvim'
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-telescope/telescope.nvim'
    Plug 'folke/lsp-trouble.nvim'
    Plug 'folke/todo-comments.nvim'
    Plug 'folke/zen-mode.nvim'
    Plug 'simrat39/symbols-outline.nvim'
endif

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

colorscheme onedark

highlight SignifySignAdd ctermfg=114 guifg=#98C379
highlight SignifySignChange ctermfg=180 guifg=#E5C07B
highlight SignifySignDelete ctermfg=204 guifg=#E06C75

let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']
let g:python3_host_prog = '/usr/bin/python3'
let g:onedark_terminal_italics = 1

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

if !exists('g:vscode')
    luafile ~/.config/nvim/lua/plugins.lua
    luafile ~/.config/nvim/lua/statusline.lua
endif

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

nnoremap <silent> <leader>q :SymbolsOutline<CR>
nnoremap <silent> <leader>e :LspTroubleToggle<CR>
nnoremap <silent> <leader>w :bd!<CR>
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

nnoremap <leader>P :lua require('utils').perform_upload()<CR>

if exists('g:vscode')
    nnoremap <silent> <leader>h :call VSCodeNotify('workbench.action.navigateLeft')<CR>
    nnoremap <silent> <leader>l :call VSCodeNotify('workbench.action.navigateRight')<CR>
    nnoremap <silent> <leader>j :call VSCodeNotify('workbench.action.navigateDown')<CR>
    nnoremap <silent> <leader>k :call VSCodeNotify('workbench.action.navigateUp')<CR>

    nnoremap <silent> <leader>f :call VSCodeNotify('workbench.action.quickOpen')<CR>
    nnoremap <silent> <leader>w :call VSCodeNotify('workbench.action.closeWindow')<CR>
    nnoremap <silent> <leader>v :call VSCodeNotify('workbench.action.splitEditor')<CR>

    nnoremap <silent> gr :call VSCodeNotify('editor.action.goToReferences')<CR>

    nnoremap <silent> <C-k> :call VSCodeNotify('workbench.action.navigateBack')<CR>
    nnoremap <silent> <C-j> :call VSCodeNotify('workbench.action.navigateNext')<CR>

    inoremap <silent> <C-j> :call VSCodeNotify('selectNextSuggestion')<CR>
    inoremap <silent> <C-k> :call VSCodeNotify('selectPrevSuggestion')<CR>
    nnoremap <silent> <leader>T :call VSCodeNotify('workbench.action.terminal.toggleTerminal')<CR>
endif

fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun

augroup SZYKOL
    autocmd!
    autocmd BufWritePost *.tex :TexlabBuild
    " autocmd BufWritePost * :lua require('utils').perform_upload()
    " autocmd BufWritePre * :call TrimWhitespace()
    autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank()
augroup END
