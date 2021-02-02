#!/bin/bash

KEY=$1

if [[ -z $KEY ]]; then
  echo "The cyphering key is empty."
  exit 1
fi

SYSTEM_PATH="$HOME"
REPO_PATH="$DOTFILES_DIR"

# List of files and directories to encrypt, relative to the $HOME directory.
declare -a FILES_TO_ENCRYPT=(
  ".tellus"
  ".secrets"
  ".z"
  ".zsh_history"
  "BitBarPlugins"
)

# Encrypt files or directories
function encrypt() {
  SOURCE=$1
  DESTINATION=$2
  echo "Encrypting '$SOURCE' into '$DESTINATION'"
  # This function throws a "tar: Removing leading '/' from member names" warning, but it can be safely ignored.
  # See https://unix.stackexchange.com/questions/59243/tar-removing-leading-from-member-names#comment81782_59243 for more info.
  tar --create --file - --gzip -- "$SOURCE" | openssl aes-256-cbc -e -out "$DESTINATION" -k $KEY
}

# Encrypt all the files declared above
for ORIGINAL_FILENAME in "${FILES_TO_ENCRYPT[@]}"; do
  ORIGINAL_PATH="$SYSTEM_PATH/$ORIGINAL_FILENAME"
  DESTINATION_PATH="$REPO_PATH/$ORIGINAL_FILENAME.encrypted"
  encrypt $ORIGINAL_PATH $DESTINATION_PATH
done
