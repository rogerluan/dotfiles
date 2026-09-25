#!/bin/bash

################################################################################
### Update the repo with the latest files in the system
################################################################################

FONT_AND_COLOR_THEMES_DIR="$HOME/Library/Developer/Xcode/UserData/FontAndColorThemes"
CODE_SNIPPETS_DIR="$HOME/Library/Developer/Xcode/UserData/CodeSnippets"

echo "Encrypting necessary files…"
source $DOTFILES_DIR/_encrypt.sh $1

# Paseo rewrites ~/.paseo/config.json atomically (so it can't be symlinked);
# snapshot the daemon-config subset here on each repo update instead.
echo "Copying ~/.paseo/config.json…"
mkdir -p $DOTFILES_DIR/.paseo
cp $HOME/.paseo/config.json $DOTFILES_DIR/.paseo/config.json

echo "Copying Xcode font and color themes…"
cp -r $FONT_AND_COLOR_THEMES_DIR $DOTFILES_DIR/Xcode
echo "Copying Xcode code snippets…"
cp -r $CODE_SNIPPETS_DIR $DOTFILES_DIR/Xcode

echo "✅ Done!"
echo "   Make sure you export your latest Terminal .terminal file:"
echo "   Open Terminal -> Preferences -> Profiles -> Default -> Export…"
echo "   And move it to $DOTFILES_DIR/Terminal"
