# Getting Started

## Installation

1. Run:
```bash
curl -fsSL https://raw.githubusercontent.com/c1ph3rC4t/c1ph3rD0ts/refs/heads/main/install/install.sh | tee install.sh
chmod +x ./install.sh
./install.sh
```

2. If you are using ZSH create or update your `.zshrc` to source the config:
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

3. Reload your shell or open a new terminal. To reload:
```sh
source ~/.zshrc
```
