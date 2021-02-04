#!/bin/bash

KEY="$1"

function decrypt() {
  SOURCE=$1
  echo "Decrypting from '$SOURCE'"
  # Extract to the same folder where it was encrypted from
  openssl aes-256-cbc -d -in $SOURCE -k $KEY | tar -v --extract --gzip --file - -C /
}

SYSTEM_PATH="$HOME"
REPO_PATH="$DOTFILES_DIR"

# Decrypt all files with .encrypted extension in this folder.
for ENCRYPTED_FILE in $(find . -name '*.encrypted'); do
  decrypt "$REPO_PATH/$ENCRYPTED_FILE"
done
