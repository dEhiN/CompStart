# CompStart

## Purpose

CompStart is a tool that allows you to have programs open automatically when your computer starts. It currently only works on Windows. But doesn't Windows already allow that through Task Manager and the startup folders, you ask? Well, here's how CompStart is different: you can open up specific tabs and browser windows alongside the installed programs. For example, you could open up a specific Word document, a Chrome window with 3 tabs, and the Google Chat Chrome app, all instantaneously after you log in.

CompStart will also allow you to quickly and easily change the programs and sites you want to open. Using the previous example, let's say you finished working on the Word document. You can easily remove that from the startup list, so CompStart will only open the Chrome window with 3 tabs and the Google Chat Chrome app.

## Installation

#### For non-devs

Currently, the installation process is manual. If you want to use this tool for yourself, you will need to be comfortable with using the command line, editing the Windows startup folder, and changing JSON configuration files manually. See the [releases](https://github.com/dEhiN/CompStart/releases) section to find the files to download. There will be setup instructions included. Follow them and you can start using CompStart for yourself!

#### For devs

The installation instructions are essentially the same as above if you just want to use the tool. However, if you want to install CompStart to work on it, depending on what you want to do, you have 2 options:

1. If you want to contribute to this program, read the **How to help** section first. Once you get in touch with me, let me know what you want to do, and I can add you as a contributor to the repository.

2. If you want to play around with what I've created on your own, you can fork this repository. I encourage you to read the **How to help** section. I also ask that if you publish anything you create based on this project, please credit me as applicable. Finally, it would be nice if you let me know.

## How to help

#### First Steps

If you'd like to contribute to this program, please get in touch! On my GitHub profile page, you'll find how to reach me. My profile page is: https://github.com/dEhiN.

Next, read through the following sections:

1. **Technical Details**
2. **Listing of Files and Folders**

Finally, check out the project board at https://github.com/users/dEhiN/projects/4, and familiarize yourself with the open issues and work.

All work I've contributed is well documented and my commits are pretty detailed. However, if there's something you're not sure about, you can always connect with me.

#### Technical Details

CompStart consists of a Batch file, a PowerShell script, and a JSON config file. The Batch file starts off the whole process. A shortcut to the Batch file will be put into the Windows Start Menu folder, and it will run the Powershell script. The Batch file is interactive, and first asks the user if they want to run the script. This ensures that a user could start their computer without having all their startup programs run whenever they want.

As of 2024-11-19, there is now a Python command-line tool that can be used to update the JSON file. The Python tool is converted into an executable using the Python module _PyInstaller_. The default startup data is now Windows Calculator, Windows Notepad, and Google Chrome open to just the Google homepage.

As of 2023-10-27, the Powershell script and Batch file both work and I use them on my work laptop. However, the JSON file has to be manually created or updated. There is a JSON Schema file that can be used to know how the JSON file data should be structured. Additionally, as of 2024-03-10, the JSON file being used comes with some default data, namely to open up Windows Calculator, Windows Notepad, and Google Chrome with 3 tabs - Google, Facebook, and X (formerly Twitter).

## Directory Structure

#### Legend

- L<#> = Folder level or the number of subdirectories down from the project root which is level 1
- D = Directory (Folder)
- F = File

#### Folder: root (/) -- L1
- D _devenv_ - A folder containing all development related files
- D _prodenv_ A folder containing all production related files
- F _.gitignore_ - The gitignore file for this project
- F _ooci-annotations.json_ - A JSON file containing the exported data from the VS Code extension _Out-of-Code Insights_; this file isn't necessary as the extension does not need to be used, but if it is used and the annotations created by the extension need to be synced, they can be exported to this file
- F _README.md_ - This README file

#### Folder: /devenv -- L2

- D _config_ - The main configuration folder for the JSON files
- D _data_ - A data folder for either old or miscellaneous data
- D _dependencies_ The Python module folder to hold all the Python scripts that _CompStart.py_ depends on
- D _experimental-content_ - A parent folder that will contain all child folders related to any code, library, or tool experimentation to possibly use in the future
- D _features_ - A parent folder that will contain a child folder for each feature branch being actively worked on (see the `README` file inside that folder for more information)
- F _CompStart.ps1_ - The main PowerShell script that sets up all the programs, browser windows, and tabs
- F _CompStart.bat_ - A Batch script that is run on Windows startup and calls _CompStart.ps1_
- F _CompStart.py_ - A Python script that's the starting point for the Python command-line tool that can be used to modify the JSON startup data

#### Folder: /prodenv -- L2

- D _assets_ - A folder containing all release-related assets
- D _packages_ - A folder containing all package files, or artifacts, for each release, as either ZIP or MSI files
- D _releases_ - A folder containing all files related to each official release; this will NOT be the package file but all content that needs to go into a package artifact
- D _scripts_ - A folder containing scripts pertaining to production, such as creating a release

#### Folder: /devenv/config -- L3

- D _schema_ - A folder containing the JSON schema files
- F _default_startup.json_ The JSON data file that holds the default startup data used when first created a startup data file
- F _startup_data.json_ The main JSON data file that holds all the up-to-date startup data used by the _CompStart_ PowerShell script

#### Folder: /devenv/data -- L3

- D _data/misc-data_ - A folder containing any non-code related files such as text files with planning information, etc.
- D _data/old-data_ - A folder containing any old or original code files to keep for posterity or just in case
- D _data/test-data_ - A folder containing any data generated during testing

#### Folder: /devenv/dependencies -- L3

- See each specific Python script in this folder for further details

#### Folder: /devenv/experimental_content -- L3

- See the _Readme_ in this folder for further details

#### Folder: /devenv/features -- L3

- See the _Readme_ in this folder for further details

#### Folder: /prodenv/assets -- L3

- See the _Readme_ in this folder for further details

#### Folder: /prodenv/packages -- L3

- See the _Readme_ in this folder for further details

#### Folder: /prodenv/releases -- L3

- See the _Readme_ in this folder for further details

#### Folder: /prodenv/scripts -- L3

- See the _Readme_ in this folder for further details

#### Folder: /devenv/config/schema -- L4

- F _startup_data.schema.json_ The schema file for the _startup_data_ JSON file that's used for validation
- F _startup_item.schema.json_ The schema file for a specific startup item that's used for validation

#### Folder: /devenv/data/misc_data -- L4

- F _extra_info.txt_ - A text file with some relevant links including questions on Stack Overflow pertinent to this project, JSON Schema validation attempts, and online articles that all had relevance in the early stages of this project
- F _json_schema_update_ideas.txt_ - A text file with ideas for the JSON schema that were already implemented
- F _robswc_suggestions.txt_ - A text file with some project changes and enhancements from Reddit user <a href="https://www.reddit.com/u/robswc">u/robswc</a> that were already implemented
- F _md_examples.md_ - Examples of Markdown language

#### Folder: /devenv/data/old_data -- L4

- D _powershell-location-commands_ - A folder containing a single PowerShell script that was created to try and make a PowerShell equivalent of an existing Python function
- D _pre-issue80_ - A folder containing the scripts related to production that were in use prior to issue #80
- F _imports_list.txt - A text file listing all the Python import statements used by the Python CLI tool
- F _old_startup.ps1_ - The original startup PowerShell script file with all the startup data hard coded in
- F _old_setup.bat_ - A batch file that was going to act as the installer for this program but will be changed into a PowerShell script

#### Folder: /devenv/data/test-data -- L4

- D _python-tool-testing_ - A folder containing various Python scripts and JSON files all related to various testing done during the creation of the _CompStart_ Python CLI tool
- D _deploy-release-script_ - A folder containing some output files and the results of running the finished script to deploy a release for test purposes
