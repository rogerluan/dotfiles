#!/bin/bash

################################################################################
### Installs Xcode Code Snippets and Solarized Dark Theme
################################################################################

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

FONT_AND_COLOR_THEMES_DIR="$HOME/Library/Developer/Xcode/UserData/FontAndColorThemes"
CODE_SNIPPETS_DIR="$HOME/Library/Developer/Xcode/UserData/CodeSnippets"

# `cp -R src dst` copies src INTO dst once dst exists, so re-running this nested
# a FontAndColorThemes/FontAndColorThemes (and CodeSnippets/CodeSnippets) that
# Xcode then ignored. `src/.` copies the CONTENTS instead, which is idempotent.
mkdir -p "$FONT_AND_COLOR_THEMES_DIR" "$CODE_SNIPPETS_DIR"
cp -R "$DIR/FontAndColorThemes/." "$FONT_AND_COLOR_THEMES_DIR/"
cp -R "$DIR/CodeSnippets/." "$CODE_SNIPPETS_DIR/"

# Set Xcode appearance to Dark Mode
defaults write com.apple.dt.Xcode IDEAppearance -int 2

# Select Solarized Dark as the current dark theme in Xcode.
defaults write com.apple.dt.Xcode XCFontAndColorCurrentDarkTheme -string "Solarized Dark.xccolortheme"

echo " * Xcode code snippets and theme installed successfully!"
