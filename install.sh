#!/usr/bin/env bash

set -e

echo "Bootstrapping personal Codespaces environment..."

# 1. Install system-level dependencies

sudo apt-get update

sudo apt-get install -y stow tmux ripgrep fd-find curl build-essential

# 2. Install the latest stable Neovim

echo "Installing Neovim..."

curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz

sudo rm -rf /opt/nvim

sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz

sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim

rm nvim-linux-x86_64.tar.gz

# 3. Install Quarto CLI

echo "Installing Quarto..."

QUARTO_DEB_URL=$(curl -s https://api.github.com/repos/quarto-dev/quarto-cli/releases/latest | grep "browser_download_url.*linux-amd64.deb" | cut -d '"' -f 4)

curl -sL "$QUARTO_DEB_URL" -o quarto.deb

sudo apt-get install -y ./quarto.deb

rm quarto.deb

# 4. Install Starship Prompt

echo "Installing Starship..."

curl -sS https://starship.rs/install.sh | sh -s -- -y

if ! grep -q "starship init bash" ~/.bashrc; then

    echo 'eval "$(starship init bash)"' >> ~/.bashrc

fi

# 5. Setup Neovim Python provider

echo "Setting up Neovim Python provider..."

mkdir -p ~/.virtualenvs

python3 -m venv ~/.virtualenvs/neovim

~/.virtualenvs/neovim/bin/pip install pynvim jupyter_client cairosvg plotly kaleido pnglatex pyperclip nbformat

# 6. Stow configurations

echo "Stowing dotfiles..."

cd "$(dirname "${BASH_SOURCE[0]}")"

mkdir -p ~/.config

# Stow the specific directories present in your repository[cite: 1]

stow -t ~ nvim

stow -t ~ tmux

stow -t ~ kitty

stow -t ~ ipython

# 7. Setup Tmux Plugin Manager (TPM)

echo "Setting up Tmux Plugin Manager (TPM)..."

if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then

  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

fi

# Headlessly install plugins based on your stowed tmux.conf[cite: 1]

~/.tmux/plugins/tpm/bin/install_plugins

echo "Dotfiles successfully installed! Ready for kitten ssh."
