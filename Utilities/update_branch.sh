#!/bin/bash

# Usage:
# /path/to/this/script --base-org:rogerluan --repo-name:dotfiles --target:someorg:perhapsabranch

set -e # Immediately rethrows exceptions

BASE_ORG="${1##--base-org:}" # e.g. 'rogerluan'
REPO_NAME="${2##--repo-name:}" # e.g. 'dotfiles'
BASE_REPO_SLUG="$BASE_ORG/$REPO_NAME" # e.g. 'rogerluan/dotfiles'
TARGET_BRANCH="${3##--target:}" # e.g. 'rogerluan-fix-important-feature'

echo "Received parameters:"
echo -e "\t - BASE_ORG = '$BASE_ORG'"
echo -e "\t - REPO_NAME = '$REPO_NAME'"
echo -e "\t - TARGET_BRANCH = '$TARGET_BRANCH'"
echo

# Preconditions
echo " * Checking Preconditions * "
echo " * Precondition 1: ensure git status clean"
if [[ ! -z "$(git status --porcelain)" ]]; then
  echo "    * ❌ Git status is not clean. Commit or stash pending changes before proceeding."
  exit 1
else
  echo "    * ✅ Git status is clean."
fi

echo " * Precondition 2: ensure hub is installed"
which hub > /dev/null
if [[ $? != 0 ]]; then
  echo "    * ❌ hub is not installed. Install hub before proceeding."
  echo "    * You can install hub by running: brew install hub"
  echo "    * Once you have installed hub, run the deployment script again."
  exit 1
else
  echo "    * ✅ hub is installed."
fi

echo " * Precondition 3: ensure GITHUB_TOKEN is set"
if [[ -z "$GITHUB_TOKEN" ]]; then
  echo "    * ❌ GITHUB_TOKEN environment variable is not set."
  echo "    * 'cmd + double click' on this link to see how to create a personal access token:"
  echo "    * https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token"
  echo "    * Once you have your token, set it as GITHUB_TOKEN in your environment variables."
  exit 1
else
  echo "    * ✅ GITHUB_TOKEN environment variable is set."
fi

echo " * Precondition 4: ensure we're in the right repository"
if ! [[ "$(git config --get remote.origin.url)" =~ $BASE_REPO_SLUG ]]; then
  echo "    * ❌ We're not in the right repository."
  echo "    * The current directory doesn't belong to the repository '$BASE_REPO_SLUG'"
  echo "    * Change to the right directory to proceed."
  exit 1
else
  echo "    * ✅ We're in the right repository: '$BASE_REPO_SLUG'"
fi

echo " * All preconditions check."

git rev-parse --verify "$TARGET_BRANCH" >/dev/null
if [[ $? = 0 ]]; then
  echo "Checking out to an existing local branch: $TARGET_BRANCH"
  git checkout "$TARGET_BRANCH"
else
  echo "Checking out to a new local branch: $TARGET_BRANCH"
  git checkout -b revolter/fix-slack-head-branch --track origin/revolter/fix-slack-head-branch
  echo "Switched to a new branch '$TARGET_BRANCH'"
fi

echo "Merging master into the current branch, '$TARGET_BRANCH'"
git merge master -m "Merge master into $TARGET_BRANCH"
echo "Pushing the changes to remote..."
git push

echo "Checking out to master"
git checkout master

echo "✅ Done! Now '$TARGET_BRANCH' is up-to-date with '$BASE_REPO_SLUG:master'!"
