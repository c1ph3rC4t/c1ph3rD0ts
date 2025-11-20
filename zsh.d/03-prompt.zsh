# Run set up oh my posh if installed
if command -v oh-my-posh &>/dev/null; then
    eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh.json 2>/dev/null || true)"
fi

# Starship setup
if command -v starship &>/dev/null; then
    set-long-prompt() {
        eval "$(starship init zsh 2>/dev/null || true)"
    }

    precmd_functions+=(set-long-prompt)

    set-short-prompt() {
      if [[ $PROMPT != "%F{#8caaee}%f$(starship module directory)%F{#8caaee}─%f$(starship module character)" ]]; then
        PROMPT="%F{#8caaee}%f$(starship module directory)%F{#8caaee}─%f$(starship module character)"
        zle .reset-prompt
      fi
    }

    zle-line-finish() { set-short-prompt }
    zle -N zle-line-finish

    trap 'set-short-prompt; return 130' INT
fi
