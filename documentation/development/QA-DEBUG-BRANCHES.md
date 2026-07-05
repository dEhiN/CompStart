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

This branch debugs a problem that was found while working issue 11. That issue was developing a feature for the Python CLI tool - the ability for a user to create a new startup data file from scratch. During testing, it was discovered that sometimes the startup items didn't start correctly.

## 2. debug/89-fix-release-deployment-script

This branch works on 2 issues - one is an actual fix and the other is a code refactor. As mentioned in issue 89 on GitHub, the deployment script `DeployRelease.ps1` main menu has an option 6, but that option isn't recognized by the script. Additionally, the main menu code currently uses multiple separate `if` statement blocks to check the user's choice. This can be refactored to use a `switch` statement.

## 3. debug/issue111

This branch fixes an issue that was occurring specifically when trying to run VS Code as a startup item. Due to how VS Code (specifically, the `Code.exe` application) started up, when a shell window ran VS Code, there would be logging data printed to the shell window. This caused the shell window - for example, the one that ran `CompStart.ps1` - to become a parent to all the VS Code processes. As a result, the shell window wouldn't close and if it were manually closed, VS Code as an application would close.


_Last Updated: 2026-07-01_
