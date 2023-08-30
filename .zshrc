autoload -Uz compinit
compinit

source ${ZDOTDIR:-$HOME}/.antidote/antidote.zsh
antidote load ${ZDOTDIR:-$HOME}/.zsh_plugins.txt

eval "$(starship init zsh)"
# source <(kubectl completion zsh)
# source <(helm completion zsh)

export PATH="$PATH:/usr/local/go/bin:$HOME/go/bin/"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
