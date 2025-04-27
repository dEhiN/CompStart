# CompStart Directory Structure

The following is an outline of the project structure using this legend:

- L<#> = Folder level or the number of subdirectories down from the project root which is level 1
- D = Directory (Folder)
- F = File

## L1

### Folder: root (/)

- D _devenv_ - A folder containing all development related files
- D _prodenv_ A folder containing all production related files
- F _.gitignore_ - The gitignore file for this project
- F _ooci-annotations.json_ - A JSON file containing the exported data from the VS Code extension _Out-of-Code Insights_; this file isn't necessary as the extension does not need to be used, but if it is used and the annotations created by the extension need to be synced, they can be exported to this file
- F _README.md_ - This README file

## L2

### Folder: /devenv

- D _config_ - The main configuration folder for the JSON files
- D _data_ - A data folder for either old or miscellaneous data
- D _dependencies_ The Python module folder to hold all the Python scripts that _CompStart.py_ depends on
- D _experimental-content_ - A parent folder that will contain all child folders related to any code, library, or tool experimentation to possibly use in the future
- D _features_ - A parent folder that will contain a child folder for each feature branch being actively worked on (see the `README` file inside that folder for more information)
- F _CompStart.ps1_ - The main PowerShell script that sets up all the programs, browser windows, and tabs
- F _CompStart.bat_ - A Batch script that is run on Windows startup and calls _CompStart.ps1_
- F _CompStart.py_ - A Python script that's the starting point for the Python command-line tool that can be used to modify the JSON startup data

### Folder: /prodenv

- D _assets_ - A folder containing all release-related assets
- D _packages_ - A folder containing all package files, or artifacts, for each release, as either ZIP or MSI files
- D _releases_ - A folder containing all files related to each official release; this will NOT be the package file but all content that needs to go into a package artifact
- D _scripts_ - A folder containing scripts pertaining to production, such as creating a release

## L3

### Folder: /devenv/config

- D _schema_ - A folder containing the JSON schema files
- F _default_startup.json_ The JSON data file that holds the default startup data used when first created a startup data file
- F _startup_data.json_ The main JSON data file that holds all the up-to-date startup data used by the _CompStart_ PowerShell script

### Folder: /devenv/data

- D _data/misc-data_ - A folder containing any non-code related files such as text files with planning information, etc.
- D _data/old-data_ - A folder containing any old or original code files to keep for posterity or just in case
- D _data/test-data_ - A folder containing any data generated during testing

### Folder: /devenv/dependencies

- See each specific Python script in this folder for further details

### Folder: /devenv/experimental_content

- See the _Readme_ in this folder for further details

### Folder: /devenv/features

- See the _Readme_ in this folder for further details

### Folder: /prodenv/assets

- See the _Readme_ in this folder for further details

### Folder: /prodenv/packages

- See the _Readme_ in this folder for further details

### Folder: /prodenv/releases

- See the _Readme_ in this folder for further details

### Folder: /prodenv/scripts

- See the _Readme_ in this folder for further details

## L4

### Folder: /devenv/config/schema

- F _startup_data.schema.json_ The schema file for the _startup_data_ JSON file that's used for validation
- F _startup_item.schema.json_ The schema file for a specific startup item that's used for validation

### Folder: /devenv/data/misc_data

- F _extra_info.txt_ - A text file with some relevant links including questions on Stack Overflow pertinent to this project, JSON Schema validation attempts, and online articles that all had relevance in the early stages of this project
- F _json_schema_update_ideas.txt_ - A text file with ideas for the JSON schema that were already implemented
- F _robswc_suggestions.txt_ - A text file with some project changes and enhancements from Reddit user <a href="https://www.reddit.com/u/robswc">u/robswc</a> that were already implemented
- F _md_examples.md_ - Examples of Markdown language

### Folder: /devenv/data/old_data

- D _powershell-location-commands_ - A folder containing a single PowerShell script that was created to try and make a PowerShell equivalent of an existing Python function
- D _pre-issue80_ - A folder containing the scripts related to production that were in use prior to issue #80
- F \_imports_list.txt - A text file listing all the Python import statements used by the Python CLI tool
- F _old_startup.ps1_ - The original startup PowerShell script file with all the startup data hard coded in
- F _old_setup.bat_ - A batch file that was going to act as the installer for this program but will be changed into a PowerShell script

### Folder: /devenv/data/test-data

- D _python-tool-testing_ - A folder containing various Python scripts and JSON files all related to various testing done during the creation of the _CompStart_ Python CLI tool
- D _deploy-release-script_ - A folder containing some output files and the results of running the finished script to deploy a release for test purposes

_Last Updated: 2025-04-27_
