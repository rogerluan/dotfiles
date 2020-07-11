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
echo -n "Plese enter the email you'd like to register with your GitHub SSH key: "
read email
echo "Next, press enter. Then create a memorable passphrase"
ssh-keygen -t rsa -b 4096 -C $email

# Add your SSH key to the ssh-agent
# Start the ssh-agent in the background
eval "$(ssh-agent -s)"
# Automatically load keys into the ssh-agent and store passphrases in the keychain
# Host *
#   AddKeysToAgent yes
#   UseKeychain yes
#   IdentityFile ~/.ssh/id_rsa
printf "Host *\n  AddKeysToAgent yes\n  UseKeychain yes\n  IdentityFile ~/.ssh/id_rsa\n" >> ~/.ssh/config

# Add your SSH private key to the ssh-agent and store your passphrase in the keychain
ssh-add -K ~/.ssh/id_rsa

# Copy the contents of the id_rsa.pub file to clipboard
cat ~/.ssh/id_rsa.pub | toClipboard
echo "Copied SSH key to clipboard!"
echo "Opening Safari, create a descriptive title to describe this computer and paste the key there"
open -a safari https://github.com/settings/ssh/new
