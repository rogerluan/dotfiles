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

# rbenv - https://github.com/rbenv/rbenv
echo " * Installing rbenv and ruby-build"
brew install rbenv ruby-build
echo " * rbenv installed successfully!"

# Ruby - https://www.ruby-lang.org/en/
echo " * Installing Ruby 2.7.5"
rbenv install 2.7.5
rbenv global 2.7.5
echo " * Ruby 2.7.5 installed successfully!"

# hub - https://hub.github.com
echo " * Installing hub"
brew install hub
echo " * hub installed successfully!"

# xcode-install - https://github.com/xcpretty/xcode-install
echo " * Installing xcode-install"
gem install xcode-install
echo " * xcode-install installed successfully!"

# Heroku - https://devcenter.heroku.com/articles/heroku-cli
echo " * Installing Heroku"
brew tap heroku/brew
brew install heroku
echo " * Heroku installed successfully!"

# Make - https://www.gnu.org/software/make/manual/make.html
echo " * Updating Make"
brew install make
echo " * Make updated successfully!"

echo " * Installing BitBar"
brew install bitbar
echo " * BitBar installed successfully!"
