#!/bin/bash

################################################################################
### Configure Commit Signing (GPG)
################################################################################

set -x # Logs every command on Terminal

function toClipboard {
 if command -v pbcopy > /dev/null; then
   pbcopy
 elif command -v xclip > /dev/null; then
   xclip -i -selection c
 else
   echo "No clipboard tool found. Here's what you need to paste into the developer console:"
   cat -
 fi
}

brew install gnupg
echo "Press enter next"
gpg --full-generate-key

gpg --list-secret-keys --keyid-format LONG

echo "The GPG KEY ID is the ID that comes after e.g. 'sec rsa4096/<your_key_id_here>'"
echo "Enter your GPG KEY ID here:"
read -r GPG_KEY_ID

git config --global user.signingkey $GPG_KEY_ID
git config --global commit.gpgsign true
git config --global commit.signingkey $GPG_KEY_ID
gpg --armor --export $GPG_KEY_ID | toClipboard

open -a safari https://github.com/settings/gpg/new

echo "To configure commit signing via SourceTree, download GPG Suite from https://gpgtools.org"
