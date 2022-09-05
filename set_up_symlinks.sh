#!/bin/bash

################################################################################
### Set up symbolic links
################################################################################

# TODO: Make this script idempotent

# DOTFILES_DIR may have not been initialized yet, if this is the first time setting up .zshrc
source .exports

ln -s $DOTFILES_DIR/.gemrc $HOME/.gemrc
ln -s $DOTFILES_DIR/.zshrc $HOME/.zshrc
ln -s $DOTFILES_DIR/.zshenv $HOME/.zshenv
ln -s $DOTFILES_DIR/.aliases $HOME/.aliases
ln -s $DOTFILES_DIR/.exports $HOME/.exports
ln -s $DOTFILES_DIR/.paths $HOME/.paths
ln -s $DOTFILES_DIR/.markdownlintrc $HOME/.markdownlintrc

# TODO: We might not need this, this is why it's commented out. After going through the setup
# steps in a new machine, check if the powerline shell utility works out of the box. If so,
# then these lines can be safely deleted.
# INSTALLED_POWERLINE_SHELL_BINARY_PATH=`find $HOME/.pyenv \( -name 'powerline-shell' \)`
# POWERLINE_SHELL_BINARY_SYMLINK_PATH="/usr/local/bin/powerline-shell"
# sudo ln -s $POWERLINE_SHELL_BINARY_PATH $POWERLINE_SHELL_BINARY_SYMLINK_PATH
