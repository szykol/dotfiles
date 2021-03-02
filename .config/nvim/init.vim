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

" Plug 'kyazdani42/nvim-web-devicons'
" Plug 'ms-jpq/chadtree', {'branch': 'chad', 'do': 'python3 -m chadtree deps'}
" Plug 'tjdevries/express_line.nvim'
Plug 'romgrk/barbar.nvim'
Plug 'szykol/statusline.nvim'
Plug 'lewis6991/gitsigns.nvim'
Plug 'tpope/vim-fugitive'
Plug 'rafi/awesome-vim-colorschemes'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'puremourning/vimspector'
Plug 'szw/vim-maximizer'

Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
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
set guicursor=n-v-c:block-Cursor
set termguicolors
set mouse=a
set nohlsearch

let &stl = " %f %m"
let g:gruvbox_italicize_strings = 1
let g:gruvbox_contrast_dark = 'hard'

colo gruvbox

highlight DiffAdd    ctermfg=114 guifg=#98c379 cterm=none gui=none guibg=none ctermbg=none ctermbg=237 guibg=#3c3836
highlight DiffChange ctermfg=180 guifg=#e5c07b cterm=none gui=none guibg=none ctermbg=none ctermbg=237 guibg=#3c3836
highlight DiffDelete ctermfg=180 guifg=#BE0F34 cterm=none gui=none guibg=none ctermbg=none ctermbg=237 guibg=#3c3836

let g:completion_enable_auto_paren = 1
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
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-s>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>p', '<cmd>lua vim.lsp.vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  end
  local servers = {'pyls_ms', 'vimls', 'clangd', 'texlab', 'tsserver' }
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

:lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "cpp", "bash", "python", "typescript", "javascript" },
  highlight = {
    enable = true,              -- false will disable the whole extension
    disable = { "c", "rust" },  -- list of language that will be disabled
  },
}
EOF

:lua <<EOF
local actions = require('telescope.actions')
require('telescope').setup{
  defaults = {
    mappings = {
      i = {
        -- To disable a keymap, put [map] = false
        -- ["<c-x>"] = false,
        -- Otherwise, just set the mapping to the function that you want it to be.
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
      },
    },
  }
}
EOF

:lua <<EOF
  require('gitsigns').setup {
  signs = {
        add          = {hl = 'DiffAdd'   , text = '│', numhl='GitSignsAddNr'},
        change       = {hl = 'DiffChange', text = '│', numhl='GitSignsChangeNr'},
        delete       = {hl = 'DiffDelete', text = '│', numhl='GitSignsDeleteNr'},
        topdelete    = {hl = 'DiffDelete', text = '‾', numhl='GitSignsDeleteNr'},
        changedelete = {hl = 'DiffChange', text = '│', numhl='GitSignsChangeNr'},
    },
  }
EOF

let mapleader = " "
nn <silent> <leader>n :noh<CR>
tno <silent> <Esc> <C-\><C-n>
nn <silent> <leader>j :lua vim.lsp.diagnostic.goto_next()<CR>
nn <silent> <leader>k :lua vim.lsp.diagnostic.goto_prev()<CR>

" moving cursor on wrapped lines
" noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
" noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')

nnoremap <silent> <leader>F <cmd>Telescope find_files<cr>
nnoremap <silent> <leader>f <cmd>Telescope git_files<cr>
nnoremap <silent> <leader>rg <cmd>Telescope grep_string<cr>
nnoremap <silent> <leader>b <cmd>Telescope buffers<cr>
nnoremap <silent> <leader>y <cmd>Telescope help_tags<cr>

nnoremap <silent> <leader>e :bn<CR>
nnoremap <silent> <leader>q :bp<CR>
nnoremap <silent> <leader>w :bd<CR>
nnoremap <silent> <leader>s :set list!<CR>
nnoremap <silent> <leader>o o<CR><Up>
nnoremap <silent> <leader>gs :Gstatus<CR>
nnoremap <silent> <leader>gc :Git commit<CR>
nnoremap <silent> <leader>gn :GitGutterNextHunk<CR>
nnoremap <silent> <leader>gp :GitGutterPrevHunk<CR>
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
