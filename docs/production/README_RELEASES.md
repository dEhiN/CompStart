# CompStart/prodenv/releases

Parent folder to store all release data. Each release will be set up using the structure outlined below.

## Directory Structure

### Major Versions

Major versions will have a directory that starts with `v` followed by the version number. For example, `v1` would be for all content related to release version _1_.

### Minor Versions

Minor versions will have a directory that starts with `m` followed by the version number, and will be a subdirectory to the major version. For example, `v1/m1` would be for all content related to release version _1.1_.

### Tags

There is no third level of versioning, but tags might be added to a release, such as `alpha`. Tags should be added to the end of the release version number and preceded by a hyphen. For example, the very first release of `CompStart` was release version _1.1-alpha_.

### Subdirectories

Within each major-minor directory tree structure, a subdirectory will be created for each release version. This will be considered the release folder. The subdirectory will be named the same as the release version, including the tag, if there is one. For example, release version _1.1-alpha_ is located at `releases/v1/m1/1.1-alpha`.
<br>
<br>

## Release Contents

### Artifacts

Each release folder will generally contain the following artifacts

- `CompStart`: A directory holding the scripts, config files, executables, etc. that make up the _CompStart_ tool
- `release-notes`: A directory holding any information related to the release
- `instructions.txt`: A text file containing instructions on how to install _CompStart_.

### Artifact Details

The `CompStart` folder will have the directory structure that's necessary for the tool to work. For example, the files `CompStart.bat`, `CompStart.ps1`, and `CompStart.exe` should all be inside this folder at what would be considered the root level. There should be a `config` folder also at this root level, and that folder should house the `startup_data.json` file, as well as any other config related data.

The `release-notes` directory will contain a Markdown file, called `release-notes.md`, with release information, including a link to the download page for the associated release package. This may seem redundant, but this file will be posted to GitHub as the release notes.

The `instructions.txt` file currently contains information on the installation steps for _CompStart_.
<br>
<br>

## Creating a Release

To automate the process for creating a release, run the `/prodenv/scripts/DeployRelease.ps1` PowerShell script. This script is interactive and can used both to create a release and a package for a release. See `/docs/prodenv-docs/SCRIPTS.md` for more detailed information on how to use it.

_Last Updated: 2025-07-20_
