# Pull updates
git pull

# Install new deps
yay -S --needed --noconfirm $(cat ./deps)

# Install Code extensions
cat code-extensions | xargs -L 1 code --install-extension
