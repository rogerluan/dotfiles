#!/bin/bash

KEY="$1"

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
  # Which Claude account belongs in which slot: the ACCOUNT_LABEL_* /
  # ACCOUNT_UUID_* pins read by bin/claude. Kept out of the repo in plaintext
  # because it names orgs and this repo is public, but it has to be SOME kind of
  # synced, or a new machine silently loses both the launch label and the
  # identity guard (which is inert without a pin to compare against).
  ".config/claude-accounts"
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
  # Flatten any nested path into a single filename: set_up_encrypted_resources.sh
  # globs the repo root at -maxdepth 1, so ".config/foo.encrypted" would never be
  # found (and would need a repo directory to be written into). The tarball
  # carries the real path, so the archive's own name is free to be anything.
  DESTINATION_PATH="$REPO_PATH/${ORIGINAL_FILENAME//\//-}.encrypted"
  encrypt "$ORIGINAL_PATH" "$DESTINATION_PATH"
done
