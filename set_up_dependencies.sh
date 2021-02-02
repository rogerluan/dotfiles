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

# Danger - https://danger.systems
echo " * Installing Danger"
brew install danger/tap/danger-swift
echo " * Danger installed successfully!"

# Prettier - https://prettier.io
echo " * Installing Prettier"
brew install prettier
echo " * Prettier installed successfully!"

# # ktlint - https://github.com/pinterest/ktlint
# echo " * Installing ktlint"
# brew install ktlint
# echo " * ktlint installed successfully!"

# # Arena - https://github.com/finestructure/Arena
# echo " * Installing Arena"
# brew install finestructure/tap/arena
# echo " * Arena installed successfully!"

# Arena - https://github.com/peripheryapp/periphery
echo " * Installing Periphery"
brew tap peripheryapp/periphery
brew install periphery
echo " * Periphery installed successfully!"

# Make - https://www.gnu.org/software/make/manual/make.html
echo " * Updating Make"
brew install make
echo " * Make updated successfully!"

echo " * Installing BitBar"
brew install bitbar
echo " * BitBar installed successfully!"
