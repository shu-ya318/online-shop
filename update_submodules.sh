#!/bin/sh
# update_submodules.sh

# stop script on error
set -e

echo "STEP 1: Pulling latest changes for main project"
# Include git fetch and merge
git pull

echo "STEP 2: Syncing, initializing, and updating submodules"
# Sync submodule URLs to point to the correct remote repository
git submodule sync --recursive
# Update and initialize submodules to the latest commit
git submodule update --init --recursive

echo "STEP 3: Updating submodules to the latest commit of the remote branch"
git submodule update --remote --merge --recursive

echo "STEP 4: Staging updated submodule pointers"
git add online-shop-frontend online-shop-backend

echo "STEP 5: Review the status"
git status

echo "Project and submodules are updated to their latest branch versions!"
echo "Review the changes above, then run 'git commit' to finalize."
