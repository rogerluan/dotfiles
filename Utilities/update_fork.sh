#!/bin/bash

set -e # Immediately rethrows exceptions

BASE_ORG="${1##--base-org:}" # e.g. 'rogerluan'
REPO_NAME="${2##--repo-name:}" # e.g. 'dotfiles'
BASE_REPO_SLUG="$BASE_ORG/$REPO_NAME" # e.g. 'rogerluan/dotfiles'
TARGET_ARGUMENT="${3##--target:}" # e.g. 'someoneelse:anotherbranch'

FORK_ORG="${TARGET_ARGUMENT%:*}" # e.g. 'someoneelse'
FORK_BRANCH="${TARGET_ARGUMENT#*:}" # e.g. 'anotherbranch'
FORK_AND_BRANCH="$FORK_ORG/$REPO_NAME:$FORK_BRANCH" # e.g. 'someoneelse/dotfiles:anotherbranch'
FORK_REPO_SLUG="$FORK_ORG/$REPO_NAME"

echo "Received parameters:"
echo -e "\t - BASE_ORG = '$BASE_ORG'"
echo -e "\t - REPO_NAME = '$REPO_NAME'"
echo -e "\t - FORK_ORG = '$FORK_ORG'"
echo -e "\t - FORK_BRANCH = '$FORK_BRANCH'"
echo

TEMP_DIR=$(mktemp -d -t 'update-fork-temp-dir')
CURRENT_DIR=$PWD

echo "Cloning '$FORK_REPO_SLUG' into '$TEMP_DIR'"
git clone "git@github.com:$FORK_REPO_SLUG.git" $TEMP_DIR
cd $TEMP_DIR

echo "Adding a remote called 'upstream' from '$BASE_REPO_SLUG'"
git remote add upstream https://github.com/$BASE_REPO_SLUG.git

echo "Fetch everything from '$BASE_REPO_SLUG'"
git fetch upstream

echo "Checking out to '$FORK_BRANCH', the branch that needs to be updated"
git checkout $FORK_BRANCH

echo "Merging $BASE_REPO_SLUG:master into $FORK_AND_BRANCH"
git merge upstream/master -m "Merge $BASE_REPO_SLUG:master into $FORK_AND_BRANCH"

echo "Pushing merge to remote"
git push

echo "Deleting temp dir ($TEMP_DIR) created to clone '$FORK'"
rm -rf $TEMP_DIR

cd $CURRENT_DIR

echo "✅ Done! Now '$FORK_AND_BRANCH' is up-to-date with '$BASE_REPO_SLUG'!"
