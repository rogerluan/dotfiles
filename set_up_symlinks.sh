#!/bin/bash

################################################################################
### Set up symbolic links
################################################################################

# DOTFILES_DIR may have not been initialized yet, if this is the first time setting up .zshrc
source .exports

ln -s $DOTFILES_DIR/.gemrc $HOME/.gemrc
ln -s $DOTFILES_DIR/.zshrc $HOME/.zshrc
ln -s $DOTFILES_DIR/.zshenv $HOME/.zshenv
ln -s $DOTFILES_DIR/.aliases $HOME/.aliases
ln -s $DOTFILES_DIR/.exports $HOME/.exports
ln -s $DOTFILES_DIR/.paths $HOME/.paths
ln -s $DOTFILES_DIR/.markdownlintrc $HOME/.markdownlintrc
