#!/bin/bash

################################################################################
### Update the repo with the latest files in the system
################################################################################

echo "Encrypting necessary files…"
source $DOTFILES_DIR/_encrypt.sh $1

FONT_AND_COLOR_THEMES_DIR="$HOME/Library/Developer/Xcode/UserData/FontAndColorThemes"
CODE_SNIPPETS_DIR="$HOME/Library/Developer/Xcode/UserData/CodeSnippets"
echo "Copying ~/.config/powerline-shell/config.json…"
cp $HOME/.config/powerline-shell/config.json $DOTFILES_DIR/Terminal/powerline-shell-config.json

echo "Copying Xcode font and color themes…"
cp -r $FONT_AND_COLOR_THEMES_DIR $DOTFILES_DIR/Xcode
echo "Copying Xcode code snippets…"
cp -r $CODE_SNIPPETS_DIR $DOTFILES_DIR/Xcode

echo "✅ Done!"
echo "   Make sure you export your latest Terminal .terminal file:"
echo "   Open Terminal -> Preferences -> Profiles -> Default -> Export…"
echo "   And move it to $DOTFILES_DIR/Terminal"
