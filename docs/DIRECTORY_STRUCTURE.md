# CompStart Directory Structure

The following is an outline of the project structure using this legend:

- L<#> = Folder level or the number of subdirectories down from the project root, which is level 1
- D = Directory (Folder)
- F = File

## L1

### Folder: root (/)

- D _devenv_ - A folder containing all development related files
- D _docs_ - A folder containing all documentation related files
- D _prodenv_ - A folder containing all production related files
- F _.gitignore_ - The project gitignore file
- F _README.md_ - The main project README file
- F _CHANGELOG.md_ - The project changelog file

## L2

### Folder: /devenv

- D _config_ - The main configuration folder for the JSON files
- D _data_ - A data folder for either old or miscellaneous data
- D _dependencies_ - The Python module folder to hold all the dependencies for _CompStart.py_, see the _/docs/TECHNICAL_DETAILS.md_ file for further details
- D _experimental-content_ - See the _/docs/devenv-docs/EXPERIMENTAL-CONTENT.md_ file for further details
- D _features_ - See the _/docs/devenv-docs/FEATURES.md_ file for further details
- See the _/docs/TECHNICAL_DETAILS.md_ file for details on the _CompStart_ Batch, PowerShell, and Python scripts

### Folder: /docs

- D _devenv-docs_ - All README files for the _devenv_ folder
- D _prodenv-docs_ - All README files for the _prodenv_ folder
- F _DIRECTORY_STRUCTURE.md_ - This file
- F _TECHNICAL_DETAILS.md_ - A Markdown file explaining the technical details of _CompStart_ in terms of how it works and the components involved

### Folder: /prodenv

- D _assets_ - See the _/docs/prodenv-docs/ASSETS.md_ file for further details
- D _packages_ - See the _/docs/prodenv-docs/PACKAGES.md_ file for further details
- D _releases_ - See the _/docs/prodenv-docs/RELEASES.md_ file for further details
- D _scripts_ - See the _/docs/prodenv-docs/SCRIPTS.md_ file for further details

## L3

### Folder: /devenv/config

- D _schema_ - A folder containing the JSON schema files
- See the _/docs/TECHNICAL_DETAILS.md_ file for details on the JSON config files

### Folder: /devenv/data

- D _data/misc-data_ - A folder containing any non-code related files such as text files with planning information, etc.
- D _data/old-data_ - A folder containing any old or original code files to keep for posterity
- D _data/test-data_ - A folder containing any data generated during testing

## L4

### Folder: /devenv/config/schema

- See the _/docs/TECHNICAL_DETAILS.md_ file for details on the JSON schema files

### Folder: /devenv/data/misc_data

- F _extra_info.txt_ - A text file with some relevant links including questions on Stack Overflow pertinent to this project, JSON Schema validation attempts, and online articles that all had relevance in the early stages of this project
- F _json_schema_update_ideas.txt_ - A text file with ideas for the JSON schema that were already implemented
- F _robswc_suggestions.txt_ - A text file with some project changes and enhancements from Reddit user <a href="https://www.reddit.com/u/robswc">u/robswc</a> that were already implemented
- F _md_examples.md_ - Examples of Markdown language

### Folder: /devenv/data/old_data

- D _powershell-location-commands_ - A folder containing a single PowerShell script that was created to try and make a PowerShell equivalent of an existing Python function
- D _pre-issue80_ - A folder containing the scripts related to production that were in use prior to issue #80
- F _imports_list.txt_ - A text file listing all the Python import statements used by the Python CLI tool
- F _old_startup.ps1_ - The original startup PowerShell script file with all the startup data hard coded in
- F _old_setup.bat_ - A batch file that was going to act as the installer for this program

### Folder: /devenv/data/test-data

- D _python-tool-testing_ - A folder containing various Python scripts and JSON files all related to various testing done during the creation of the _CompStart_ Python CLI tool
- D _release-install-script_ - A folder containing some output files and the results of running the release deployment script for test purposes

_Last Updated: 2025-07-19_
