#!/bin/bash

# Shamelessly copied from https://stackoverflow.com/a/246128/4075379
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
DESTDIR="$HOME/Library/Developer/Xcode/UserData/FontAndColorThemes"

echo " * Installing Solarized Dark for Xcode. . ."
mkdir -p $DESTDIR

if [[ $1 = "-f" || $1 = "--force" || $1 = "force" ]]; then
  rm $DESTDIR/Solarized\ Dark.xccolortheme
fi

# Note: although this creates a symlink, once this file is edited by Xcode,
# Xcode creates its own copy for it, so it won't be version-controlled, unfortunately.
ln -s $DIR/Solarized\ Dark.xccolortheme $DESTDIR/Solarized\ Dark.xccolortheme

# Set Xcode appearance to Dark Mode
defaults write com.apple.dt.Xcode IDEAppearance -int 2

# Select Solarized Dark as the current dark theme in Xcode.
defaults write com.apple.dt.Xcode XCFontAndColorCurrentDarkTheme -string "Solarized Dark.xccolortheme"

echo " * Done! Solarized Dark for Xcode has been installed."
