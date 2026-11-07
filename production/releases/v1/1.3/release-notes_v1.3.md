# Release Details

## Title

CompStart-1.3

## Version

1.3

## Production Date

October 30, 2026

## Description

The project documentation was completely rewritten with the help of ChatGPT. It is more accurate and also streamlined. The fix that was made to `CompStart.ps1` in _v1.1_ turned out to not be a proper fix, so the issue still existed. After more research, a new possible fix was implemented.
<hr>
<hr>

# Release Notes

## Installation Notes

The following steps are suggested for downloading and installing this release:

1. Before getting started, please read the project [README](https://github.com/dEhiN/CompStart).
2. Next, download the release package _CompStart-1.3.zip_ from the Assets section below.
3. Unzip the release package to a folder of your choice.
4. After unzipping the archive package, read the _instructions.txt_ file for the installation instructions.

# Release Changes

## Commit Details

**Commit count:** 170

**Full Changelog:** [CompStart-1.3](https://github.com/dEhiN/CompStart/compare/CompStart-1.2...CompStart-1.3)

## Changes Summary

* Simplified the on-disk directory structure for releases and packages.
* Fixed the release notes for each release prior to _CompStart-1.2_.
* Changed the naming convention for the release notes file to include the release version number.
* Created a Bash shell script to automatically synchronise the three master branches: `main`, `releases`,  and `qa-testing-debug`.
* Rewrote all the project documentation with the help of ChatGPT (see issue #137 for more details).
* Implemented a new fix for the bug noted in issues #111 and #120 (see issue #140 for more details).

## Issues Addressed

* #123
* #129
* #132
* #135
* #137
* #140

## Detailed Pull Request History

* Merging branch::dEhiN/issue129 to branch::main by @dEhiN in https://github.com/dEhiN/CompStart/pull/131
* Merging branch::release/issue123 to branch::releases by @dEhiN in https://github.com/dEhiN/CompStart/pull/133
* Merging branch::release/issue132 to branch::releases by @dEhiN in https://github.com/dEhiN/CompStart/pull/134
* Merging branch::dEhiN/issue135 to branch::main by @dEhiN in https://github.com/dEhiN/CompStart/pull/136
* Merging branch::documentation/issue137 to branch::main by @dEhiN in https://github.com/dEhiN/CompStart/pull/139
* Merge branch::debug/issue140 into branch::qa-testing-debug by @dEhiN in https://github.com/dEhiN/CompStart/pull/141