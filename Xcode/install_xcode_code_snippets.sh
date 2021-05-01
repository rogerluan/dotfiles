#!/bin/bash

################################################################################
### Installs Xcode Code Snippets and Solarized Dark Theme
################################################################################

FONT_AND_COLOR_THEMES_DIR="$HOME/Library/Developer/Xcode/UserData/FontAndColorThemes"
CODE_SNIPPETS_DIR="$HOME/Library/Developer/Xcode/UserData/CodeSnippets"

cp -r $DOTFILES_DIR/Xcode/FontAndColorThemes $FONT_AND_COLOR_THEMES_DIR
cp -r $DOTFILES_DIR/Xcode/CodeSnippets $CODE_SNIPPETS_DIR 

# Set Xcode appearance to Dark Mode
defaults write com.apple.dt.Xcode IDEAppearance -int 2

# Select Solarized Dark as the current dark theme in Xcode.
defaults write com.apple.dt.Xcode XCFontAndColorCurrentDarkTheme -string "Solarized Dark.xccolortheme"

