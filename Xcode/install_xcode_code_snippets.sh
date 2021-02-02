#!/bin/bash

################################################################################
### Moves Xcode Code Snippets from the repo to Xcode directory
################################################################################

FONT_AND_COLOR_THEMES_DIR="$HOME/Library/Developer/Xcode/UserData/FontAndColorThemes"
CODE_SNIPPETS_DIR="$HOME/Library/Developer/Xcode/UserData/CodeSnippets"

cp -r $DOTFILES_DIR/Xcode/FontAndColorThemes $FONT_AND_COLOR_THEMES_DIR
cp -r $DOTFILES_DIR/Xcode/CodeSnippets $CODE_SNIPPETS_DIR 
