# CompStart/development/qa-debug

<hr>

## Purpose

Parent folder to hold all QA or debugging branches while being worked on.

## Structure

Each active QA/debug branch should have its own subfolder named after the issue number. The branch name will use a _debug_ prefix. For example:

- **Branch Name:** _debug/<rest_of_branch_name>_
- **Folder Name:** _qa-debug/issue-<issue_number>_

When listing the branch name below, the full branch name should be used.

<hr>

## Current Branches


## Past Branches (newest > oldest)

### 1. debug/57-troubleshoot-using-issue-11-json-file

This branch debugs a problem that was found while working issue eleven. That issue was developing a feature for the Python CLI tool - the ability for a user to create a new startup data file from scratch. During testing, it was discovered that sometimes the startup items didn't start correctly.

## 2. debug/89-fix-release-deployment-script

This branch works on 2 issues - one is an actual fix and the other is a code refactor. As mentioned in issue 89 on GitHub, the deployment script `DeployRelease.ps1` main menu has an option 6, but that option isn't recognized by the script. Additionally, the main menu code currently uses multiple separate `if` statement blocks to check the user's choice. This can be refactored to use a `switch` statement.

_Last Updated: 2026-07-01_
