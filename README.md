# Getting Started

## Installation

1. Create or update your `.zshrc` to source the config:
```sh
cat << 'EOF' > ~/.zshrc
# Source zsh config files
for config in $HOME/.config/zsh.d/*.zsh; do
  [ -f "$config" ] && source "$config"
done
EOF
```

**Note:** This will overwrite your existing `.zshrc`. If you already have one that you are fond of, make sure to **back it up first**:
```sh
cp ~/.zshrc ~/.zshrc.bak
```

**Note:** If you would like multiple users to use the same dot files stored in `/path/to/zsh` then do:
```sh
cat << 'EOF' > ~/.zshrc
# Source zsh config files
for config in /path/to/zsh.d/*.zsh; do
  [ -f "$config" ] && source "$config"
done
EOF
```
instead.

2. Reload your shell or open a new terminal. To reload:
```sh
source ~/.zshrc
```

3. Include gitconfig:
```sh
echo -e "[include]\n\tpath = ~/.config/gitconfig\n$(cat "$HOME/.gitconfig")" > $HOME/.gitconfig
```
