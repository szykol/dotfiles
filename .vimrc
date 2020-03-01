set nu relativenumber
set sts=4
set ts=2
set et

syntax on
set hidden

set completeopt-=preview
filetype plugin indent on

"curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
"    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
          silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
              \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
            autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    endif

call plug#begin()
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
call plug#end()

let g:airline_theme='deus'
