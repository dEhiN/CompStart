## Release Title

**CompStart-0.1-beta** _(Second Unofficial Release)_

## Release Version

**0.1-beta**

## Description

This is the second (unofficial) release of **CompStart**. It includes the completed Python CLI tool to allow users to modify the startup file, including the ability to create a new one. This version will be a beta release to facilitate real-world testing of the Python CLI tool.

_Note: Currently, **CompStart** will need to be manually installed._

## Installation Notes

The following steps are suggested for downloading and installing this release:

1. Before getting started, please read the project [README](https://github.com/dEhiN/CompStart).
2. Next, download the release package by clicking on the **Release Tag** link above.
3. Unzip the release package to a folder of your choice.
4. After unzipping the archive package, read the _instructions.txt_ file for manual installation instructions.

Note: A recommended folder to extract the package to is _AppData\\Local_ within the local Windows profile. For example, if the Windows profile is named _Example_, the full path would be _C:\\Users\\Example\\AppData\\Local_.

## What's Changed

* Creation of the _0.1-beta_ release directory structure and files.
* Creation of a `Python` CLI tool to facilitate easy manipulation of the startup data:
   * Creation of an initial `Python` script to act as the CLI entry point to the tool.
   * Creation of modularized helper `Python` scripts to segregate aspects of the tool functionality.
   * Structuring of the CLI tool to use the helper scripts as dependencies.
* Restructuring of the `JSON` startup data to use two data files instead of one: 
   * One that contains default values.
   * One that contains user specific data.
* Restructuring of the project directory structure:
   * Creation of a _config_ folder to store all `JSON` content.
   * Creation of an _experimental_content_ folder to store work that's not officially being introduced as a feature.
   * Renaming of the parent folder for all feature branch work.
   * Naming convention change to the parent folder for each specific release.
* Research on three different experimental content functionalities:
   * A PowerShell installer for **CompStart**.
   * Use of the Python module `PyInstaller` to bundle all the CLI tool scripts into one _exe_ file.
   * Use of the Python module `TKinter` to develop a GUI replacement for the CLI tool.
* Creation of a new `JSON` configuration schema for the purpose of validating the `JSON` data files.
* Standardization of the file naming convention for the startup scripts and the CLI tool to reflect proper branding.
* Finalization of the _0.1-beta_ release at commit [e9cbf10](https://github.com/dEhiN/CompStart/commit/e9cbf10beb1a573696d647f6212fedc8229845e5).

## Detailed Pull Request History

* Merging branch::dEhiN/issue5 to branch::features/startup_data_modifier_tool by @dEhiN in https://github.com/dEhiN/CompStart/pull/23
* Merging branch::dEhiN/issue26 to branch::dEhiN/issue25 by @dEhiN in https://github.com/dEhiN/CompStart/pull/27
* Merging branch::dEhiN/issue25 to branch::dEhiN/issue4 by @dEhiN in https://github.com/dEhiN/CompStart/pull/29
* Merging branch::dEhiN/issue22 to branch::dEhiN/issue4 by @dEhiN in https://github.com/dEhiN/CompStart/pull/30
* Merging branch::dEhiN/issue20 to branch::features/startup_data_modifier_tool by @dEhiN in https://github.com/dEhiN/CompStart/pull/32
* Merging branch::dEhiN/issue33 to branch::dEhiN/issue31 by @dEhiN in https://github.com/dEhiN/CompStart/pull/35
* Merging branch::dEhiN/issue31 to branch::dEhiN/issue4 by @dEhiN in https://github.com/dEhiN/CompStart/pull/37
* Merging branch::dEhiN/issue4 to branch::features/startup_data_modifier_tool by @dEhiN in https://github.com/dEhiN/CompStart/pull/39
* Merging branch::features/powershell_installer to branch:main by @dEhiN in https://github.com/dEhiN/CompStart/pull/40
* Merging branch::features/startup_data_modifier_tool to branch:main by @dEhiN in https://github.com/dEhiN/CompStart/pull/41
* Merging branch::dEhiN/issue43 to branch::main by @dEhiN in https://github.com/dEhiN/CompStart/pull/48
* Update branch::releases for release::CompStart-1.1-beta by @dEhiN in https://github.com/dEhiN/CompStart/pull/49

**Release Commit Count**: 638

**Full Changelog**: [CompStart-0.1-beta](https://github.com/dEhiN/CompStart/compare/CompStart-0.1-alpha...CompStart-0.1-beta)

___

## Historical Versioning Note:

This release was originally developed under the versioning pattern _1.1_ (labeled as _CompStart-1.1-beta_). Consequently, commit messages within this range reference version _1.1_. In March 2026, the project's versioning schema was retroactively adjusted to _0.1_ for all pre-releases to ensure a clean transition to the official _1.0_ launch.