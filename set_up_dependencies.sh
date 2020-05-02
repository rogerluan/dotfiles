#!/bin/bash

################################################################################
### Install Applications
################################################################################

set -e # Immediately rethrows exceptions
set -x # Logs every command on Terminal

# Homebrew - https://brew.sh
echo " * Installing Homebrew"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
echo " * Homebrew installed successfully!"

# rbenv - https://github.com/rbenv/rbenv
echo " * Installing rbenv"
brew install rbenv ruby-build
echo " * rbenv installed successfully!"

# Ruby - https://www.ruby-lang.org/en/
echo " * Installing Ruby 2.6.5"
rbenv install 2.6.5
rbenv global 2.6.5
echo " * Ruby 2.6.5 installed successfully!"

# Yarn - https://yarnpkg.com
echo " * Installing Yarn"
brew install yarn
echo " * Yarn installed successfully!"

# hub - https://hub.github.com
echo " * Installing hub"
brew install hub
echo " * hub installed successfully!"

# Heroku - https://devcenter.heroku.com/articles/heroku-cli
echo " * Installing Heroku"
brew tap heroku/brew
brew install heroku
echo " * Heroku installed successfully!"
