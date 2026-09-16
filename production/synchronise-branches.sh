#!/bin/sh

# Define the 3 master branch names
main_branch="main"
release_branch="releases"
qa_branch="qa-testing-debug"

# Get the command line argument specifying which branch is most up to date
sync_branch=$1
