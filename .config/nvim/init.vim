function! Cond(cond, ...)
  let opts = get(a:000, 0, {})
  return a:cond ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction

call plug#begin(stdpath('data') . '/vim-plug')

Plug 'tpope/vim-commentary'
Plug 'asvetliakov/vim-easymotion', Cond(exists('g:vscode'), { 'as': 'vsc-easymotion' }) 
if !exists('g:vscode')
    Plug 'neovim/nvim-lspconfig'

    Plug 'tweekmonster/startuptime.vim'
    " Plug 'mhartington/oceanic-next'
    " Plug 'sainnhe/sonokai'
    " Plug 'pineapplegiant/spaceduck', { 'branch': 'main' }

    Plug 'mhinz/vim-signify'
    Plug 'tpope/vim-fugitive'
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'puremourning/vimspector'
    Plug 'szw/vim-maximizer'
    Plug 'kyazdani42/nvim-web-devicons'
    Plug 'glepnir/galaxyline.nvim'

    Plug 'nvim-lua/popup.nvim'
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-telescope/telescope.nvim'

    Plug 'folke/lsp-trouble.nvim'
    Plug 'folke/todo-comments.nvim'
    " Plug 'folke/zen-mode.nvim'

    Plug 'simrat39/symbols-outline.nvim'
    Plug 'psf/black'
    Plug 'onsails/lspkind-nvim'
    " Plug 'kosayoda/nvim-lightbulb'
    Plug 'kevinhwang91/nvim-bqf'
    Plug 'ray-x/lsp_signature.nvim'
    Plug 'navarasu/onedark.nvim'
    " Plug 'projekt0n/github-nvim-theme'
    Plug 'kyazdani42/nvim-tree.lua'

    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'hrsh7th/cmp-buffer'
    Plug 'hrsh7th/nvim-cmp'

    Plug 'hrsh7th/cmp-vsnip'
    Plug 'hrsh7th/vim-vsnip'
    Plug 'hrsh7th/cmp-path'
    Plug 'hrsh7th/cmp-calc'
    Plug 'f3fora/cmp-spell'

    Plug 'akinsho/toggleterm.nvim'
    " Plug 'nvim-lualine/lualine.nvim'
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
set completeopt=menu,menuone,noselect
set clipboard+=unnamedplus
set noequalalways

let &stl = " %f %m"
let g:gruvbox_italicize_strings = 1
let g:gruvbox_contrast_dark = 'hard'
let g:edge_style = 'neon'

colorscheme onedark

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

set lcs=trail:.,tab:>-

let mapleader = " "
nn <silent> <leader>n :noh<CR>

tno <silent> <Esc> <C-\><C-n>
tno <silent> <C-h> <C-\><C-n><C-W>h
tno <silent> <C-j> <C-\><C-n><C-W>j
tno <silent> <C-l> <C-\><C-n><C-W>l
tno <silent> <C-k> <C-\><C-n><C-W>k

nn <silent> <leader>sj :lua vim.lsp.diagnostic.goto_next()<CR>
nn <silent> <leader>sk :lua vim.lsp.diagnostic.goto_prev()<CR>

noremap <C-c> <c-[>
nnoremap <silent> <leader>F <cmd>Telescope find_files<cr>
nnoremap <silent> <leader>f <cmd>Telescope git_files<cr>
nnoremap <silent> <leader>rg <cmd>Telescope grep_string<cr>
nnoremap <silent> <leader>b <cmd>Telescope buffers<cr>
nnoremap <silent> <leader>y <cmd>Telescope help_tags<cr>
nnoremap <silent> <leader>g <cmd>Telescope git_branches<cr>
" nnoremap <silent> <leader>t <cmd>Telescope file_browser<cr>

nnoremap <silent> <leader>q :SymbolsOutline<CR>
nnoremap <silent> <leader>e :LspTroubleToggle<CR>
nnoremap <silent> <leader>w :bd!<CR>
nnoremap <silent> <leader>gs :Gstatus<CR>
nnoremap <silent> <leader>gc :Git commit<CR>
nnoremap <silent> <leader>gj <plug>(signify-next-hunk)
nnoremap <silent> <leader>gk <plug>(signify-prev-hunk)
nnoremap <silent> <leader>m :MaximizerToggle!<CR>
nnoremap <silent> <leader>v :vsplit<cr>
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

nnoremap <silent> <C-h> :wincmd h<CR>
nnoremap <silent> <C-l> :wincmd l<CR>
nnoremap <silent> <C-j> :wincmd j<CR>
nnoremap <silent> <C-k> :wincmd k<CR>

nnoremap <silent> <leader>T :ToggleTerm<CR>
nnoremap <silent> <leader>+ :vertical resize +5<CR>
nnoremap <silent> <leader>- :vertical resize -5<CR>

" inoremap <silent><expr> <C-Space> compe#complete()
" inoremap <silent><expr> <CR>      compe#confirm('<CR>')
" inoremap <silent><expr> <C-e>     compe#close('<C-e>')

nnoremap <leader>P :lua require('utils').perform_upload()<CR>
" nnoremap <silent> K <cmd>lua require('lspsaga.hover').render_hover_doc()<CR>

nnoremap <silent><leader>t :NvimTreeToggle<CR>
nnoremap <silent><leader>nr :NvimTreeRefresh<CR>
nnoremap <silent><leader>nn :NvimTreeFindFile<CR>

if exists('g:vscode')
    nnoremap <silent> <leader>h :call VSCodeNotify('workbench.action.navigateLeft')<CR>
    nnoremap <silent> <leader>l :call VSCodeNotify('workbench.action.navigateRight')<CR>
    nnoremap <silent> <leader>j :call VSCodeNotify('workbench.action.navigateDown')<CR>
    nnoremap <silent> <leader>k :call VSCodeNotify('workbench.action.navigateUp')<CR>

    nnoremap <silent> <leader>f :call VSCodeNotify('workbench.action.quickOpen')<CR>
    nnoremap <silent> <leader>w :call VSCodeNotify('workbench.action.closeActiveEditor')<CR>
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
    " autocmd BufWritePost *.py :silent Black
    " autocmd BufWritePost * :lua require('utils').perform_upload()
    " autocmd BufWritePre * :call TrimWhitespace()
    autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank()
augroup END

highlight SignifySignAdd guifg=#58d464
highlight SignifySignChange ctermfg=180 guifg=#00F7FC
highlight SignifySignDelete ctermfg=204 guifg=#E06C75

highlight LspDiagnosticsDefaultError ctermfg=204 guifg=#E06C75
highlight LspDiagnosticsDefaultInformation ctermfg=39 guifg=#61AFEF
highlight LspDiagnosticsDefaultHint ctermfg=38 guifg=#56B6C2
highlight LspDiagnosticsDefaultWarning ctermfg=180 guifg=#E5C07B

highlight LspDiagnosticsUnderlineError cterm=underline ctermfg=204 gui=underline guifg=#E06C75
highlight LspDiagnosticsUnderlineInformation cterm=underline ctermfg=39 gui=underline guifg=#61AFEF
highlight LspDiagnosticsUnderlineHint cterm=underline ctermfg=38 gui=underline guifg=#56B6C2
highlight LspDiagnosticsUnderlineWarning cterm=underline ctermfg=180 gui=underline guifg=#E5C07B

highlight LspDiagnosticsVirtualTextError ctermfg=204 ctermbg=236 guifg=#E06C75 guibg=#2C323C
highlight LspDiagnosticsVirtualTextInformation ctermfg=39 ctermbg=236 guifg=#61AFEF guibg=#2C323C
highlight LspDiagnosticsVirtualTextHint ctermfg=38 ctermbg=236 guifg=#56B6C2 guibg=#2C323C
highlight LspDiagnosticsVirtualTextWarning ctermfg=180 ctermbg=236 guifg=#E5C07B guibg=#2C323C

highlight TelescopeResultsBorder guifg=#98c379
highlight TelescopePreviewBorder guifg=#98c379

"  master
