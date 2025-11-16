# Getting Started

## Installation

1. Create or update your `.zshrc` to source the config:
```sh
echo 'source $HOME/.config/zsh/main.zsh' > ~/.zshrc
```

**Note:** This will overwrite your existing `.zshrc`. If you already have one that you are fond of, make sure to **back it up first**:
```sh
cp ~/.zshrc ~/.zshrc.bak
```

**Note:** If you would like multiple users to use the same dot files stored in `/path/to/zsh` then do:
```sh
echo 'source /path/to/zsh/main.zsh' > ~/.zshrc
```
instead.

2. Reload your shell or open a new one. To reload:
```sh
source ~/.zshrc
```
