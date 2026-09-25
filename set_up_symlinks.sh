#!/bin/bash

################################################################################
### Set up symbolic links
################################################################################

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# DOTFILES_DIR may have not been initialized yet, if this is the first time setting up .zshrc
source "$DIR/.exports"

# `-s` symlink, `-f` replace whatever is already there, `-n` treat an existing
# symlink-to-a-directory as a file to replace rather than descending into it.
# Without -f this printed a wall of "ln: …: File exists" on every re-run.
for FILE in \
  .aliases \
  .exports \
  .gemrc \
  .markdownlintrc \
  .paths \
  .python-version \
  .ruby-version \
  .zprofile \
  .zshenv \
  .zshrc
do
  ln -sfn "$DOTFILES_DIR/$FILE" "$HOME/$FILE"
done

# Paseo config: COPIED, not symlinked — Paseo rewrites it atomically (temp +
# rename), which replaces a symlink with a real file. Deploy only when absent so
# an existing live config isn't clobbered. Changes are captured back into the
# repo by _update_repo.sh (the manual system→repo backup step).
mkdir -p $HOME/.paseo
[ -e $HOME/.paseo/config.json ] || cp $DOTFILES_DIR/.paseo/config.json $HOME/.paseo/config.json

echo " * Symlinks set up successfully!"
