# Set up zinit if it exists
if [ -f /usr/share/zinit/zinit.zsh ]; then
  source /usr/share/zinit/zinit.zsh
  unalias zi
  
  zinit snippet OMZP::sudo
fi

# Set up zoxide if it exists
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
fi

source $HOME/.config/zsh/prompt.zsh
source $HOME/.config/zsh/completion.zsh
