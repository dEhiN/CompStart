## Release Title

**CompStart-1.0**

## Release Version

**1.0**

## Description

This is the first official release of **CompStart**. It includes a PowerShell installer script.

## Installation Notes

The following steps are suggested for downloading and installing this release:

1. Before getting started, please read the project [README](https://github.com/dEhiN/CompStart)
2. Next, download the release package by clicking on the **Release Tag** link above
3. Unzip the release package to a folder of your choice
4. After unzipping the archive package, read the _instructions.txt_ file for the installation instructions

## What's Changed

* Formalizing the following experimental functionality into proper features:
    * Use of the Python module `PyInstaller` to generate an executable file for the Python CLI tool `CompStart.py`.
    * Creation of a PowerShell installer script that installs **CompStart** to the user's local app data folder and creates a shortcut to `CompStart.bat` in the user's Start Menu startup folder.
* Creation of a PowerShell script to deploy a release:
    * Gathering the full release number as input
    * Creation of folders for the major and minor release numbers in both the `releases` and `packages` directories but only when needed.
    * Creation of a full release folder in the `releases` directory when necessary.
    * Copying of all the appropriate content from `development` to the full release folder.
    * Copying of the appropriate content from `productions/assets` to the full release folder.
    * Calling of the `PyInstaller` module to generate `CompStart.exe` and then removal of the build artifacts created during generation.
    * Packaging up of the release content into a zip archive file and placing that file in the `production` directory release folder.
* Restructuring of the **CompStart** folder and its contents that constitute a release package so that the installer scripts are separated from the content to be installed
* Rewording of the content in the `instructions.txt` file to reflect the current state of **CompStart**.

## Detailed Pull Request History

## What's Changed
* Merging branch::dEhiN/issue50 to branch::releases by @dEhiN in https://github.com/dEhiN/CompStart/pull/51
* Merging branch::dEhiN/issue2 to branch::main by @dEhiN in https://github.com/dEhiN/CompStart/pull/54
* Merging branch::dEhiN/issue45 to branch::main by @dEhiN in https://github.com/dEhiN/CompStart/pull/55
* Merging branch::dEhiN/issue11 to branch::main by @dEhiN in https://github.com/dEhiN/CompStart/pull/58
* Merging branch::dEhiN/issue24 to branch::main by @dEhiN in https://github.com/dEhiN/CompStart/pull/59
* Merging branch::dEhiN/issue46 to branch::main by @dEhiN in https://github.com/dEhiN/CompStart/pull/60
* Merging branch::dEhiN/issue56 to branch::main by @dEhiN in https://github.com/dEhiN/CompStart/pull/61
* Merging branch::features/generate_python_executable to branch::dEhiN/issue52 by @dEhiN in https://github.com/dEhiN/CompStart/pull/62
* Merging branch::dEhiN/issue52 to branch::main by @dEhiN in https://github.com/dEhiN/CompStart/pull/63
* Merging branch::features/create_new_release to branch::dEhiN/issue64 by @dEhiN in https://github.com/dEhiN/CompStart/pull/67
* Merging branch::dEhiN/issue64 to branch::main by @dEhiN in https://github.com/dEhiN/CompStart/pull/68
* Merging branch::features/copy_release_content to branch::dEhiN/issue66 by @dEhiN in https://github.com/dEhiN/CompStart/pull/69
* Merging branch::dEhiN/issue66 to branch::main by @dEhiN in https://github.com/dEhiN/CompStart/pull/71
* Merging branch::dEhiN/issue70 to branch::main by @dEhiN in https://github.com/dEhiN/CompStart/pull/72
* Merging branch::features/create_release_package to branch::dEhiN/issue53 by @dEhiN in https://github.com/dEhiN/CompStart/pull/73
* Merging branch::dEhiN/issue53 to branch::main by @dEhiN in https://github.com/dEhiN/CompStart/pull/74
* Merging branch::features/cs-installer to branch::dEhiN/issue75 by @dEhiN in https://github.com/dEhiN/CompStart/pull/76
* Merging branch::dEhiN/issue75 to branch::main by @dEhiN in https://github.com/dEhiN/CompStart/pull/77
* Merging branch::dEhiN/issue28 to branch::main by @dEhiN in https://github.com/dEhiN/CompStart/pull/79
* Merging branch::dEhiN/issue80 to branch::main by @dEhiN in https://github.com/dEhiN/CompStart/pull/83
* Merging branch::dEhiN/issue84 to branch::dEhiN/issue81 by @dEhiN in https://github.com/dEhiN/CompStart/pull/85
* Merging branch::dEhiN/issue82 to branch::main by @dEhiN in https://github.com/dEhiN/CompStart/pull/87
* Merging branch::dEhiN/issue81 to branch::main by @dEhiN in https://github.com/dEhiN/CompStart/pull/91
* Merging branch::dEhiN/issue-batch-utility to branch::main by @dEhiN in https://github.com/dEhiN/CompStart/pull/92
* Merging branch::dEhiN/issue93 to branch::releases by @dEhiN in https://github.com/dEhiN/CompStart/pull/95
* Merging branch::dEhiN/issue97 to branch::main by @dEhiN in https://github.com/dEhiN/CompStart/pull/99
* Merging branch::dEhiN/issue98 to branch::releases by @dEhiN in https://github.com/dEhiN/CompStart/pull/103
* Merging branch::dEhiN/issue100 to branch::dEhiN/issue104 by @dEhiN in https://github.com/dEhiN/CompStart/pull/105
* Merging branch::dEhiN/issue102 to branch::dEhiN/issue104 by @dEhiN in https://github.com/dEhiN/CompStart/pull/106
* Merging branch::dEhiN/issue104 to branch:releases by @dEhiN in https://github.com/dEhiN/CompStart/pull/107
* Merging branch::dEhiN/issue101 to branch:qa-testing-debug by @dEhiN in https://github.com/dEhiN/CompStart/pull/109


**Release Commit Count:** 616

**Full Changelog:** [CompStart-1.0] (https://github.com/dEhiN/CompStart/compare/CompStart-0.1-beta...CompStart-1.0)
