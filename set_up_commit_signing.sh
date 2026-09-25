#!/bin/bash

################################################################################
### Configure Commit Signing (GPG)
################################################################################

set -e

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

# `brew install` on an already-installed formula is a no-op, but it still spends
# time hitting the network and — since Homebrew 6 — can stop on an
# "==> Do you want to proceed with the installation? [y/n]" prompt.
if ! brew list gnupg > /dev/null 2>&1; then
  echo " * Installing gnupg"
  brew install gnupg
else
  echo " * gnupg is already installed."
fi

# Already configured? Then there is nothing to do. Re-running this script used
# to walk through `gpg --full-generate-key` again and mint a second key, which
# then had to be uploaded to GitHub or commits would fail to verify.
EXISTING_KEY_ID="$(git config --global user.signingkey || true)"
if [ -n "$EXISTING_KEY_ID" ] && gpg --list-secret-keys "$EXISTING_KEY_ID" > /dev/null 2>&1; then
  echo " * Commit signing is already configured with key $EXISTING_KEY_ID."
  exit 0
fi

# Reuse a secret key that's already on this machine before making a new one.
if gpg --list-secret-keys > /dev/null 2>&1 && [ -n "$(gpg --list-secret-keys --with-colons | grep '^sec:' || true)" ]; then
  echo " * An existing GPG secret key was found; skipping key generation."
else
  echo "Press enter next"
  gpg --full-generate-key
fi

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
