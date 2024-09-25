#!/bin/bash

set -e # Immediately rethrows exceptions
set -x # Logs every command on Terminal

# Shamelessly copied from https://stackoverflow.com/a/246128/4075379
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Prerequisite:
# - git
# - git SSH
# - pyenv installed & running (`which python3` must point to pyenv shims)

# Install oh-my-zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installing oh-my-zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  echo "oh-my-zsh is already installed."
fi

# Install oh-my-zsh custom plugins
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

# Install powerline-shell font "Meslo Slashed"
git clone git@github.com:powerline/fonts.git --depth=1
cd fonts
# This script uses a string argument to look for font with prefixes with the given string
./install.sh "Meslo LG"
cd ..
rm -rf fonts

# Install powerline-shell
git clone git@github.com:b-ryan/powerline-shell.git --depth=1
cd powerline-shell
python3 setup.py install # Note that this must be run only after pyenv has already been installed and is
cd ..
rm -rf powerline-shell

# Open my custom Solarized Dark theme to apply it on Terminal
open $DIR/Solarized\ Dark.terminal

# Make this theme the default one
defaults write com.apple.Terminal "Default Window Settings" -string "Solarized Dark"
defaults write com.apple.Terminal "Startup Window Settings" -string "Solarized Dark"

echo "Copying $DOTFILES_DIR/Terminal/powerline-shell-config.json → $HOME/.config/powerline-shell/config.json"
mkdir -p $HOME/.config/powerline-shell/
cp $DOTFILES_DIR/Terminal/powerline-shell-config.json $HOME/.config/powerline-shell/config.json
