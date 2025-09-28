#!/bin/bash

# This script is executed inside the Dev Container as the final step of dotfile setup.
# The dotfiles repository is cloned into the default location: ~/dotfiles.

DOTFILES_PATH="$HOME/dotfiles"

# --- Install .gitconfig ---
# The .gitconfig file holds global Git user name, email, and aliases.

# Check if the file exists in the dotfiles repo
if [ -f "$DOTFILES_PATH/.gitconfig" ]; then
    echo "Copying .gitconfig from dotfiles repo to user's home directory (~/)"
    # Copy the file to the user's home directory (~/)
    cp "$DOTFILES_PATH/.gitconfig" "$HOME/.gitconfig"
else
    echo "Warning: .gitconfig not found in the dotfiles repository. Skipping copy."
fi

# You can add more dotfiles (like .bashrc, .zshrc, .vimrc) here as you grow your repo.
# Example for a .bashrc:
# if [ -f "$DOTFILES_PATH/.bashrc" ]; then
#     echo "Sourcing .bashrc from dotfiles repo"
#     source "$DOTFILES_PATH/.bashrc"
# fi

echo "Dotfiles installation complete."
