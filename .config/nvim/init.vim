set nu relativenumber
set sts=4
set ts=2
set et

syntax on

call plug#begin()
	Plug 'vim-airline/vim-airline'
	Plug 'scrooloose/nerdtree'
	Plug 'rafi/awesome-vim-colorschemes'
	Plug 'tpope/vim-fugitive'
	Plug 'majutsushi/tagbar'
	Plug 'Yggdroot/indentLine'

	Plug 'autozimu/LanguageClient-neovim', {
    		\ 'branch': 'next',
    		\ 'do': 'bash install.sh',
    		\ }
	Plug 'junegunn/fzf'
	Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
	Plug 'w0rp/ale'
call plug#end()

set hidden
let g:deoplete#enable_at_startup = 1

set completeopt-=preview

map <C-n> :NERDTreeToggle<CR>

let g:airline#extensions#tabline#enabled = 1
let g:python3_host_prog = '/bin/python3'
let g:LanguageClient_serverCommands = {
    \ 'rust': ['~/.cargo/bin/rustup', 'run', 'stable', 'rls'],
    \ 'javascript': ['/usr/local/bin/javascript-typescript-stdio'],
    \ 'javascript.jsx': ['tcp://127.0.0.1:2089'],
    \ 'python': ['/usr/bin/pyls'],
    \ 'ruby': ['~/.rbenv/shims/solargraph', 'stdio'],
    \ }
