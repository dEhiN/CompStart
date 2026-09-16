#!/bin/bash

# Define the 3 master branch names
main_branch="main"
release_branch="releases"
qa_branch="qa-testing-debug"

# Get the command line argument specifying which branch is most up to date
sync_branch=$1

# Do some validation on the argument
if [ -z $sync_branch ]; then
    echo "Missing branch name argument..."
    exit
fi

if [ $sync_branch != $main_branch ] && [ $sync_branch != $release_branch ] && [ $sync_branch != $qa_branch ]; then
    echo "Invalid branch name argument..."
    exit
fi