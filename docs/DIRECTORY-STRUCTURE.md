# CompStart Directory Structure

<hr>

The following is an outline of the project structure using this legend:

- L = Folder level or the number of subdirectories down from the project root, which is level 1
- D = Directory (Folder)
- F = File

## L1

### Folder: root (/)

- D _devenv_ - Development files
- D _docs_ - Documentation
- D _prodenv_ - Production files
- F _.gitignore_ - Project gitignore
- F _README.md_ - Project README

## L2

### Folder: /devenv

- D _config_: Configuration folder for the startup JSON files
- D _data_: Old or miscellaneous data
- D _dependencies_: Python module folder; holds all the dependencies for _CompStart.py_; see _/docs/TECHNICAL-DETAILS.md_ for more details
- D _experimental-content_: See _/docs/devenv-docs/EXPERIMENTAL-CONTENT.md_
- D _features_: See _/docs/devenv-docs/FEATURES.md_
- F _CompStart.bat_: See _/docs/devenv-docs/FEATURES.md_
- F _CompStart.ps1_: See _/docs/devenv-docs/FEATURES.md_
- F _CompStart.py_: See _/docs/devenv-docs/FEATURES.md_

### Folder: /docs

- D _devenv-docs_: Markdown documentation related to development
- D _prodenv-docs_: Markdown documentation related to production
- F _CHANGELOG.md_: Project changelog
- F _DIRECTORY-STRUCTURE.md_: Description of the project directory structure
- F _TECHNICAL-DETAILS.md_: Full technical details of _CompStart_ (how it works and the components involved)

### Folder: /prodenv

- D _assets_: See _/docs/prodenv-docs/ASSETS.md_
- D _packages_: See _/docs/prodenv-docs/PACKAGES.md_
- D _releases_: See _/docs/prodenv-docs/RELEASES.md_
- D _scripts_: See _/docs/prodenv-docs/SCRIPTS.md_

## L3

### Folder: /devenv/config

- D _schema_: Contains the JSON schema files; see _/docs/TECHNICAL-DETAILS.md_ for more details

### Folder: /devenv/data

- D _data/misc-data_: Contains non-code related files such as text files with planning information, etc.
- D _data/old-data_: Contains old or original code files designated to keep for posterity
- D _data/test-data_: Containing data generated during testing

_Last Updated: 2026-04-05_
