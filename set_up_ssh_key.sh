#!/bin/bash

################################################################################
### Configure SSH key
################################################################################

set -e # Immediately rethrows exceptions

KEY_PATH="$HOME/.ssh/id_rsa"
SSH_CONFIG="$HOME/.ssh/config"

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

# This is the very first script run on a fresh machine (via curl, before the
# repo is even cloned), so it's the right place to make sure `git` actually
# works. Without the Command Line Tools, `git clone` pops an install dialog and
# fails — leaving the clone step in the README to silently do nothing.
if ! xcode-select --print-path > /dev/null 2>&1; then
  echo "Installing Xcode Command Line Tools (required by git)…"
  xcode-select --install || true
  echo "Complete the installation dialog that just opened. Waiting…"
  until xcode-select --print-path > /dev/null 2>&1; do
    sleep 10
  done
  echo "Xcode Command Line Tools installed successfully!"
fi

mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"

# Generate new SSH key — but never clobber one that already exists. Re-running
# this script used to overwrite the key (or force you to Ctrl-C out of the
# "Overwrite (y/n)?" prompt), invalidating the key already registered on GitHub.
if [ -f "$KEY_PATH" ]; then
  echo "An SSH key already exists at $KEY_PATH — keeping it."
else
  echo -n "Please enter the email you'd like to register with your GitHub SSH key: "
  read email
  echo "Next, press enter. Then create a memorable passphrase"
  ssh-keygen -t rsa -b 4096 -C "$email" -f "$KEY_PATH"
fi

# Add your SSH key to the ssh-agent
# Start the ssh-agent in the background
eval "$(ssh-agent -s)"

# Automatically load keys into the ssh-agent and store passphrases in the keychain (when in macOS)
# Appended only once — this used to grow a duplicate `Host *` block per run.
if ! grep -q "IdentityFile ~/.ssh/id_rsa" "$SSH_CONFIG" 2>/dev/null; then
  if [[ "$(uname)" == "Darwin" ]]; then
    # macOS-specific commands here
    printf "Host *\n  AddKeysToAgent yes\n  UseKeychain yes\n  IdentityFile ~/.ssh/id_rsa\n" >> "$SSH_CONFIG"
  else
    # Linux-specific commands here
    printf "Host *\n  AddKeysToAgent yes\n  IdentityFile ~/.ssh/id_rsa\n" >> "$SSH_CONFIG"
  fi
fi

# Add your SSH private key to the ssh-agent and store passphrase in the keychain (when in macOS)
if [[ "$(uname)" == "Darwin" ]]; then
  # `-K` still works but has been deprecated in favour of `--apple-use-keychain`
  # since macOS 12, and warns loudly on every run.
  ssh-add --apple-use-keychain "$KEY_PATH"
else
  # Linux-specific commands here
  ssh-add "$KEY_PATH"
fi

# Copy the contents of the id_rsa.pub file to clipboard
cat "$KEY_PATH.pub" | toClipboard
echo "Copied SSH key to clipboard!"

# Open the SSH key URL in the default web browser
if command -v open > /dev/null; then
  open "https://github.com/settings/ssh/new"
elif command -v xdg-open > /dev/null; then
  xdg-open "https://github.com/settings/ssh/new"
else
  echo "Please open the following URL in your web browser and paste the SSH public key:"
  echo "https://github.com/settings/ssh/new"
fi
