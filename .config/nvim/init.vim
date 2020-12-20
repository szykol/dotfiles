call plug#begin(stdpath('data') . '/vim-plug')

Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'
Plug 'honza/vim-snippets'
Plug '9mm/vim-closer'
Plug 'tpope/vim-commentary'
Plug 'sainnhe/edge'
Plug 'tweekmonster/startuptime.vim'
Plug 'mizlan/termbufm'
Plug 'mhinz/vim-signify'
Plug 'SirVer/ultisnips'
Plug 'lifepillar/gruvbox8'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ryanoasis/vim-devicons'
Plug 'airblade/vim-gitgutter'
Plug 'rafi/awesome-vim-colorschemes'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

call plug#end()

set ts=2 sts=2 sw=2 et list lcs=tab:┆·,trail:·,precedes:,extends:
set hid nowrap spr sb ic scs nu rnu tgc nosmd swb=useopen scl=yes nosc noru icm=split
set udir=$HOME/.local/share/nvim/undodir udf
set cot=menuone,noinsert,noselect shm+=c
set bg=dark
let &stl = " %f %m"
let g:gruvbox_italicize_strings = 1
colo gruvbox8

let g:completion_confirm_key = "\<C-y>"
let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']
let g:python3_host_prog = '/usr/bin/python3'

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline_powerline_fonts = 1
let g:airline_theme='deus'

command! Format execute 'lua vim.lsp.buf.formatting()'

:lua << EOF
  local nvim_lsp = require("lspconfig")
  local on_attach = function(_, bufnr)
  require('completion').on_attach()
  end
  local servers = {'pyls_ms', 'vimls', 'clangd'}
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
