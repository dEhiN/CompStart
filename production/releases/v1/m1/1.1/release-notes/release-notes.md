## Release Title

CompStart-1.1

## Release Version

1.1

## Description

Minor fix to the `CompStart.ps1` script (see below).

## Installation Notes

The following steps are suggested for downloading and installing this release:

1. Before getting started, please read the project [README](https://github.com/dEhiN/CompStart)
2. Next, download the release package by clicking on the **Release Tag** link above
3. Unzip the release package to a folder of your choice
4. After unzipping the archive package, read the _instructions.txt_ file for the installation instructions

## What's Changed

* Creation of a `qa-debug` folder in `/development` to more easily track debugging or QA issues.
* Creation of a `QA-DEBUG-BRANCHES.md` file fashioned after the `FEATURE-BRANCHES.md` file.
* Resolution of bug issues #56, #89, and #111.
* Fixing the `CompStart.ps1` script to properly start programs like _Visual Studio Code_ that previously caused the startup script window to stay open (see issue #111).

## Detailed Pull Request History

* Merging branch::dEhiN/issue90 to branch:main by @dEhiN in https://github.com/dEhiN/CompStart/pull/110
* Merging branch::debug/issue111 to branch:qa-testing-debug by @dEhiN in https://github.com/dEhiN/CompStart/pull/115
* Merging branch::release/issue116 to branch:releases by @dEhiN in https://github.com/dEhiN/CompStart/pull/117

**Commit count:** 49

**Full Changelog**: [CompStart-1.1](https://github.com/dEhiN/CompStart/compare/CompStart-1.0...CompStart-1.1)