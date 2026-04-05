# CompStart Changelog

<hr>

## Historical Versioning Note:

The following two releases were originally developed under the versioning pattern _1.1_. However, in March 2026, the project's versioning schema was retroactively adjusted to _0.1_ for all pre-releases to ensure a clean transition to the official _1.0_ launch.

## CompStart-0.1-beta

Release date: 2026-04-02 (_originally: 2024-11-21_)

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

**Release Commit Count**: 638

**Full Changelog**: [CompStart-0.1-beta](https://github.com/dEhiN/CompStart/compare/CompStart-0.1-alpha...CompStart-0.1-beta)

## CompStart-0.1-alpha

Release date: 2026-03-31 (_originally: 2024-03-11_)

* Initial creation of _CompStart_ by @dEhiN in [ebf6152](https://github.com/dEhiN/CompStart/commit/ebf615262a6ff46e48cb539e626c68b5677de018).
* Refactoring of initial startup `PowerShell` script from hardcoded data to variable data.
* Creation of a `JSON` configuration schema to store user startup data.
* Creation of a `JSON` data file based on the schema with default values.
* Updating of startup `PowerShell` script to utilise the JSON config file.
* Finalization of the _0.1-alpha_ release at commit [2eb913c](https://github.com/dEhiN/CompStart/commit/2eb913c7c9bd763e31743eac1973e233b2e2b7da).

**Release Commit Count**: 210

**Full Changelog**: [CompStart-0.1-alpha](https://github.com/dEhiN/CompStart/commits/CompStart-0.1-alpha)

<hr>

<s>_These are currently being kept for posterity:_

## CompStart-1.1-beta

- Release date: 2024-11-21
- Added a Python command-line tool to assist with editing the JSON config files
- Updated the instructions to include how to use the Python tool
- For the full list of release commits: <a href=https://github.com/dEhiN/CompStart/compare/CompStart-1.1-alpha...CompStart-1.1-beta>CompStart-1.1-beta</a>

## CompStart-1.1-alpha

- Release date: 2024-03-11
- First release of _CompStart_
- Includes the PowerShell and Batch script files that are used
- Includes the JSON config and JSON schema files that are relied upon
- Includes instructions for manual installation as there is no automated installer
- Includes instructions for manual editing of the JSON config files as there is no tool to assist
- For the full list of release commits: <a href=https://github.com/dEhiN/CompStart/commits/CompStart-1.1-alpha>CompStart-1.1-alpha</a></s>

_Last Updated: 2026-04-05_
