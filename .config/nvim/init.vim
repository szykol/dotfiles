call plug#begin(stdpath('data') . '/vim-plug')

Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'
Plug 'honza/vim-snippets'
Plug '9mm/vim-closer'
Plug 'tpope/vim-commentary'
Plug 'sainnhe/edge'
Plug 'tweekmonster/startuptime.vim'
Plug 'mizlan/termbufm'
Plug 'SirVer/ultisnips'
Plug 'gruvbox-community/gruvbox'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ryanoasis/vim-devicons'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'rafi/awesome-vim-colorschemes'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

call plug#end()

filetype plugin indent on
set cc=120
set ts=4 sw=4 sts=4 et nolist lcs=eol:↵,trail:~,tab:>-,nbsp:␣,space:·
set hid nowrap spr sb ic scs nu rnu tgc nosmd swb=useopen scl=yes nosc noru icm=split
set udir=$HOME/.local/share/nvim/undodir udf
set cot=menuone,noinsert,noselect shm+=c
set bg=dark
set updatetime=500
set scrolloff=8
set guicursor=
set termguicolors
let &stl = " %f %m"
let g:gruvbox_italicize_strings = 1
let g:gruvbox_contrast_dark = 'hard'

colo gruvbox
highlight Normal guibg=none

inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

let g:completion_confirm_key = "\<C-y>"
let g:completion_enable_snippet = 'UltiSnips'

let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']
let g:python3_host_prog = '/usr/bin/python3'

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline_powerline_fonts = 1
let g:airline_theme='deus'

let g:gitgutter_sign_added = '+'
let g:gitgutter_sign_modified = '~'
let g:gitgutter_sign_removed = '-'
let g:gitgutter_sign_removed_first_line = '^'
let g:gitgutter_sign_modified_removed = '<'

command! Format execute 'lua vim.lsp.buf.formatting()'

:lua << EOF
  local nvim_lsp = require("lspconfig")
  local on_attach = function(_, bufnr)
  require('completion').on_attach()
  local opts = { noremap=true, silent=true }
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>p', '<cmd>lua vim.lsp.vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  end
  local servers = {'pyls_ms', 'vimls', 'clangd', 'texlab'}
  for _, lsp in ipairs(servers) do
      nvim_lsp[lsp].setup {
      on_attach = on_attach,
    }
  end
EOF

:lua << EOF
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    -- This will disable virtual text, like doing:
    -- let g:diagnostic_enable_virtual_text = 0
    virtual_text = true,

    -- This is similar to:
    -- let g:diagnostic_show_sign = 1
    -- To configure sign display,
    --  see: ":help vim.lsp.diagnostic.set_signs()"
    signs = true,

    -- This is similar to:
    -- "let g:diagnostic_insert_delay = 1"
    update_in_insert = true,
  }
)
EOF
command! Format execute 'lua vim.lsp.buf.formatting()'

let mapleader = " "
nn <silent> <leader>n :noh<CR>
tno <silent> <Esc> <C-\><C-n>
nn <silent> <leader>j :lua vim.lsp.diagnostic.goto_next()<CR>
nn <silent> <leader>k :lua vim.lsp.diagnostic.goto_prev()<CR>

" moving cursor on wrapped lines
noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')
nnoremap <silent> <leader>f :Files<CR>
nnoremap <silent> <leader>r :Rg<CR>
nnoremap <silent> <leader>b :Buffers<CR>
nnoremap <silent> <leader>e :bn<CR>
nnoremap <silent> <leader>q :bp<CR>
nnoremap <silent> <leader>w :bd<CR>
nnoremap <silent> <leader>s :set list!<CR>
nnoremap <silent> <leader>o o<CR><Up>
nnoremap <silent> <leader>gs :Gstatus<CR>
nnoremap <silent> <leader>gc :Gcommit<CR>
nnoremap <silent> <leader>gn :GitGutterNextHunk<CR>
nnoremap <silent> <leader>gp :GitGutterPrevHunk<CR>
vnoremap <leader>p "_dP

fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun

augroup SZYKOL
    autocmd!
    autocmd BufWritePost *.tex :TexlabBuild
    autocmd BufWritePre * :call TrimWhitespace()
augroup END
