#!/bin/bash

################################################################################
### Install Applications
################################################################################

set -e # Immediately rethrows exceptions

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

log() { echo; echo " * $*"; }

################################################################################
# Xcode Command Line Tools
#
# Nothing else here works without them — even `git` is a stub that pops the
# install dialog and then fails. That's how a fresh-machine run once left the
# repo uncloned, with every following command chasing a directory that was
# never created. Install them and BLOCK until they're actually there.
################################################################################

if ! xcode-select --print-path > /dev/null 2>&1; then
  log "Installing Xcode Command Line Tools"
  xcode-select --install || true
  echo "   Complete the installation dialog that just opened. Waiting…"
  until xcode-select --print-path > /dev/null 2>&1; do
    sleep 10
  done
  log "Xcode Command Line Tools installed successfully!"
else
  log "Xcode Command Line Tools are already installed."
fi

################################################################################
# Homebrew - https://brew.sh
#
# Guarded: the installer is interactive (sudo password + a RETURN prompt) and
# re-running it on a machine that already has Homebrew asks for both again for
# no benefit.
################################################################################

if ! command -v brew > /dev/null 2>&1; then
  log "Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  log "Homebrew installed successfully!"
else
  log "Homebrew is already installed."
fi

# Re-source the env so anything installed above is on $PATH for the rest of this
# script. NOTE: deliberately .exports + .paths and NOT .zshrc — .zshrc loads
# oh-my-zsh, which hard-refuses to load under bash ("Oh My Zsh can't be loaded
# from: /bin/bash") and returns 1, and .aliases uses zsh-only builtins such as
# `autoload`. Under `set -e` that aborted this whole script right here, which is
# what stopped every fresh-machine run short of Ruby, Python and everything after.
source "$DIR/.exports"
source "$DIR/.paths"

################################################################################
# Claude Code - https://claude.com/product/claude-code
#
# Installed early and on its own (rather than via the Brewfile) so it's
# available to help debug the rest of the setup, and because ~/.local/bin/claude
# is the path the account-selecting shim in bin/claude falls back to.
################################################################################

if [ ! -x "$HOME/.local/bin/claude" ]; then
  log "Installing Claude Code"
  curl -fsSL https://claude.ai/install.sh | bash
  log "Claude Code installed successfully!"
else
  log "Claude Code is already installed."
fi

################################################################################
# Homebrew packages
################################################################################

# Homebrew now refuses to load formulae/casks from third-party taps until the
# tap is explicitly trusted, and `brew bundle` does NOT prompt — it just skips
# them with a warning. Trust the taps the Brewfile needs, up front.
# See https://docs.brew.sh/Tap-Trust
if brew commands 2>/dev/null | grep -qx trust; then
  brew trust --tap dopplerhq/cli || true
fi

log "Installing Homebrew packages"
# Not fatal: one disabled cask or an unreachable tap shouldn't stop Ruby and
# Python from being installed. Reported at the end instead.
BREW_BUNDLE_FAILED=0
brew bundle --file="$DIR/Brewfile" || BREW_BUNDLE_FAILED=1

################################################################################
# Ruby - https://www.ruby-lang.org/en/
################################################################################

RUBY_VERSION="$(cat "$DIR/.ruby-version")"
log "Installing Ruby $RUBY_VERSION"
rbenv install --skip-existing "$RUBY_VERSION"
rbenv global "$RUBY_VERSION"
rbenv rehash
log "Ruby $RUBY_VERSION installed successfully!"

################################################################################
# Python - https://www.python.org
################################################################################

PYTHON_VERSION="$(cat "$DIR/.python-version")"
log "Installing Python $PYTHON_VERSION"
pyenv install --skip-existing "$PYTHON_VERSION"
pyenv global "$PYTHON_VERSION"
pyenv rehash
log "Python $PYTHON_VERSION installed successfully!"

if [ "$BREW_BUNDLE_FAILED" -ne 0 ]; then
  echo
  echo "WARNING: 'brew bundle' reported failures (scroll up for which). Everything"
  echo "         else finished. Fix the Brewfile entries and re-run this script."
  exit 1
fi
