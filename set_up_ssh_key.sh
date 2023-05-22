#!/bin/bash

################################################################################
### Configure SSH key
################################################################################

set -e # Immediately rethrows exceptions

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

# Generate new SSH key
echo -n "Please enter the email you'd like to register with your GitHub SSH key: "
read email
echo "Next, press enter. Then create a memorable passphrase"
ssh-keygen -t rsa -b 4096 -C "$email"

# Add your SSH key to the ssh-agent
# Start the ssh-agent in the background
eval "$(ssh-agent -s)"

# Automatically load keys into the ssh-agent and store passphrases in the keychain (when in macOS)
# Host *
#   AddKeysToAgent yes
#   UseKeychain yes
#   IdentityFile ~/.ssh/id_rsa
if [[ "$(uname)" == "Darwin" ]]; then
  # macOS-specific commands here
  printf "Host *\n  AddKeysToAgent yes\n  UseKeychain yes\n  IdentityFile ~/.ssh/id_rsa\n" >> ~/.ssh/config
else
  # Linux-specific commands here
  printf "Host *\n  AddKeysToAgent yes\n  IdentityFile ~/.ssh/id_rsa\n" >> ~/.ssh/config
fi

# Add your SSH private key to the ssh-agent and store passphrase in the keychain (when in macOS)
if [[ "$(uname)" == "Darwin" ]]; then
  # macOS-specific commands here
  ssh-add -K ~/.ssh/id_rsa
else
  # Linux-specific commands here
  ssh-add ~/.ssh/id_rsa
fi

# Copy the contents of the id_rsa.pub file to clipboard
cat ~/.ssh/id_rsa.pub | toClipboard
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
