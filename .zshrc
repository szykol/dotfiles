export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(git zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

alias gs="git status"
alias gd="git diff"
alias gc="git commit"
alias gb="git branch"
alias ga="git add"
alias gm="git merge"
alias gch="git checkout"
