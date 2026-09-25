#!/bin/bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

KEY="$1"

if [[ -z $KEY ]]; then
  echo "The cyphering key is empty."
  echo "Usage: ./set_up_encrypted_resources.sh <key>"
  exit 1
fi

function decrypt() {
  SOURCE=$1
  echo "Decrypting from '$SOURCE'"
  # Extract to the same folder where it was encrypted from
  openssl aes-256-cbc -d -in "$SOURCE" -k "$KEY" | tar -v --extract --gzip --file - -C /
}

# Decrypt every .encrypted file in this repo. Anchored on $DIR rather than
# `find .` so it works no matter where it's invoked from; a plain glob is not
# enough because every one of these files is a dotfile (.secrets.encrypted &
# co.), which `*` does not match. _encrypt.sh only ever writes them to the repo
# root, hence -maxdepth 1.
while IFS= read -r ENCRYPTED_FILE; do
  decrypt "$ENCRYPTED_FILE"
done < <(find "$DIR" -maxdepth 1 -name '*.encrypted')

echo " * Encrypted resources decrypted successfully!"
