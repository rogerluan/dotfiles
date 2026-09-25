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
# Clone into a scratch dir so a failure never leaves an untracked clone behind
# inside this repo. Skipped entirely once the fonts are present — the clone is
# ~11MB and the install triggers a slow system font-cache rebuild.
if ! ls "$HOME/Library/Fonts/Meslo LG"*"for Powerline"* > /dev/null 2>&1; then
  FONTS_TMP_DIR="$(mktemp -d)"
  trap 'rm -rf "$FONTS_TMP_DIR"' EXIT
  git clone git@github.com:powerline/fonts.git --depth=1 "$FONTS_TMP_DIR/fonts"
  # This script uses a string argument to look for font with prefixes with the given string
  (cd "$FONTS_TMP_DIR/fonts" && ./install.sh "Meslo LG")
  rm -rf "$FONTS_TMP_DIR"
  trap - EXIT
else
  echo "Powerline fonts are already installed."
fi

# Install powerline-shell
# Targets the pyenv-managed Python EXPLICITLY rather than trusting whatever
# `python3` resolves to: if this runs from a shell that predates the current
# .paths, `python3` is Homebrew's, which is PEP-668 "externally managed" and
# ships no setuptools. pip builds the package in an isolated env, so neither
# `setup.py install` (removed in modern setuptools) nor a clone of our own is
# needed.
if ! command -v pyenv > /dev/null; then
  echo "ERROR: pyenv is required — run ./set_up_dependencies.sh first." >&2
  exit 1
fi
PYENV_PYTHON="$(pyenv which python3)"
"$PYENV_PYTHON" -m pip install --upgrade "git+https://github.com/b-ryan/powerline-shell.git"
# Regenerate shims so the freshly installed `powerline-shell` binary is on PATH.
pyenv rehash

# Open my custom Solarized Dark theme to apply it on Terminal
open $DIR/Solarized\ Dark.terminal

# Make this theme the default one
defaults write com.apple.Terminal "Default Window Settings" -string "Solarized Dark"
defaults write com.apple.Terminal "Startup Window Settings" -string "Solarized Dark"

# iTerm2: install the Solarized Dark dynamic profile (colors + Meslo Powerline font)
# and make it the default profile. Dynamic profiles in this folder are loaded
# automatically on each iTerm2 launch — no GUI clicks needed.
# Docs: https://iterm2.com/documentation-dynamic-profiles.html
ITERM_DYNAMIC_PROFILES_DIR="$HOME/Library/Application Support/iTerm2/DynamicProfiles"
mkdir -p "$ITERM_DYNAMIC_PROFILES_DIR"
cp "$DIR/Solarized Dark.json" "$ITERM_DYNAMIC_PROFILES_DIR/Solarized Dark.json"

# Guid must match the one in Solarized Dark.json
defaults write com.googlecode.iterm2 "Default Bookmark Guid" -string "F5CF0F1B-5F1B-4A1C-9D3E-50145A1DED44"

# Also drop the .itermcolors preset next to the profile so it shows up in
# Preferences → Profiles → Colors → Color Presets for ad-hoc use.
ITERM_COLOR_PRESETS_DIR="$HOME/Library/Application Support/iTerm2/ColorPresets"
mkdir -p "$ITERM_COLOR_PRESETS_DIR"
cp "$DIR/Solarized Dark.itermcolors" "$ITERM_COLOR_PRESETS_DIR/Solarized Dark.itermcolors"

# Symlinked, not copied: powerline-shell only ever READS this file (see
# find_config() upstream), so there's no atomic-rewrite problem like the one
# that forces ~/.paseo/config.json to be a copy. A symlink means editing the
# repo file takes effect on the next prompt, with no re-run and no copy-back.
echo "Linking $DIR/powerline-shell-config.json → $HOME/.config/powerline-shell/config.json"
mkdir -p "$HOME/.config/powerline-shell"
ln -sfn "$DIR/powerline-shell-config.json" "$HOME/.config/powerline-shell/config.json"
