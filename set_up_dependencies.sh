#!/bin/bash

################################################################################
### Install Applications
################################################################################

set -e # Immediately rethrows exceptions
set -x # Logs every command on Terminal

# Homebrew - https://brew.sh
echo " * Installing Homebrew"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo " * Homebrew installed successfully!"

source ~/.zshrc

# Ruby - https://www.ruby-lang.org/en/
echo " * Installing Ruby"

# Installs all dependencies declared in Brewfile
brew bundle

RUBY_VERSION="$(cat ~/.ruby-version)"
rbenv install
rbenv global $RUBY_VERSION
echo " * Ruby $RUBY_VERSION installed successfully!"

PYTHON_VERSION="$(cat ~/.python-version)"
pyenv install $PYTHON_VERSION
pyenv global $PYTHON_VERSION
echo " * Python $PYTHON_VERSION installed successfully!"
