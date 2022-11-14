export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"
plugins=(git zsh-syntax-highlighting fzf zsh-autosuggestions zsh-kubectl-prompt)

source $ZSH/oh-my-zsh.sh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

alias gs="git status"
alias gd="git diff"
alias gc="git commit"
alias gb="git branch"
alias ga="git add"
alias gm="git merge"
alias gch="git checkout"
source <(kubectl completion zsh)
source <(helm completion zsh)

export PATH="$PATH:/usr/local/go/bin:$HOME/go/bin/"
RPROMPT='%{$fg[blue]%}($ZSH_KUBECTL_PROMPT)%{$reset_color%}'

export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
eval "$(starship init zsh)"

function cd() {
  builtin cd "$@"
  VIRTUALENV_DIRS=("venv/" ".venv/" "env/" ".env/" "${PWD##*/}")
  if [[ -z "$VIRTUAL_ENV" ]] ; then
    for dir in $VIRTUALENV_DIRS; do
      if [[ -d "${dir}" ]]; then
        if [[ -e "./${dir}/bin/activate" ]]; then
          source ./$dir/bin/activate
          echo "${PWD##*/}/${dir} venv activated"
          break
        fi
      fi
    done
  else
    parentdir="$(dirname "$VIRTUAL_ENV")"
    if [[ "$PWD"/ != "$parentdir"/* ]] ; then
      echo "venv deactivated"
      deactivate
    fi
  fi
}
