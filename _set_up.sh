#!/bin/bash

################################################################################
### Set up everything in the correct order
################################################################################

set -e

# Run from the repo regardless of where this was invoked from.
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd "$DIR"

source "$DIR/.exports"

# Each step runs as its OWN process rather than being `source`d. Sourcing meant
# a `set -e`/`set -x` inside any one script leaked into this one and into every
# later step, so a single non-zero command anywhere killed the entire run — and
# that is precisely what happened: set_up_dependencies.sh's `source ~/.zshrc`
# returned 1 under bash, and everything from commit signing onwards silently
# never ran. Now a failing step is named, and the rest is left to the operator:
# every step is idempotent, so re-running ./_set_up.sh after a fix is safe.
run_step() {
  echo
  echo "################################################################################"
  echo "### $1"
  echo "################################################################################"
  if ! "$DIR/$1" "${@:2}"; then
    echo
    echo "STEP FAILED: $1" >&2
    echo "Fix the cause and re-run ./_set_up.sh — every step is idempotent." >&2
    exit 1
  fi
}

run_step set_up_symlinks.sh
run_step set_up_dependencies.sh
run_step set_up_encrypted_resources.sh "$1"
run_step set_up_commit_signing.sh
run_step set_up_user_defaults.sh
run_step Terminal/set_up_terminal.sh
run_step Xcode/install_xcode_code_snippets.sh

echo
echo "################################################################################"
echo "### Done! Open a new terminal tab to pick up the new shell environment."
echo "################################################################################"
