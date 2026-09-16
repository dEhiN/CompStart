#!/bin/bash


# Define the 3 master branch names
master_branches=("main" "releases" "qa-testing-debug")


# Get the command line argument specifying which branch is most up to date
sync_branch=$1


# Do some validation on the argument
if [ -z "$sync_branch" ]; then
    echo "Missing branch name argument..."
    exit 1
fi

is_valid=false
for branch in "${master_branches[@]}"; do
    if [ "$sync_branch" == "$branch" ]; then
        is_valid=true
        break
    fi
done
if [ "$is_valid" == "false" ]; then
    echo "Invalid branch name argument..."
    exit 1
fi


# Perform the sync operations
