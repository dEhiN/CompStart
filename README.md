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

- D = Directory (Folder)
- F = File

#### Folder: root (/)

- D _devenv_ - All files related to development
- D _packages_ - Package files for each release, as either ZIP or MSI files
- D _releases_ - Files related to each official release; this will NOT be the package files but all content that needs to go into a package file
- F _README.md_ - This README
- F _.gitignore_ - The gitignore file for this project

#### Folder: /devenv

- D _config_ - Main configuration folder for the JSON files
- D _data_ - Data folder for either old or miscellaneous data
- D _dependencies_ Python module folder to hold all the Python scripts that _CompStart.py_ depends on
- D _experimental_content_ - Parent folder to hold all child folders for any experimentation done with, for example, a library to possibly use in the future
- D _features_ - Parent folder to hold child folders for each feature branch being worked on (see README inside that folder for more information)
- F _CompStart.ps1_ - Main PowerShell script that sets up all the programs, browser windows, and tabs
- F _CompStart.bat_ - A batch file that is run on Windows startup and calls _startup.ps1_
- F _CompStart.py_ - The Python command-line tool that can be used to modify the JSON startup data

### Folder: /devenv/config

- D _schema_ - A folder to hold the JSON schema files
- F _default_startup.json_ The data file that holds the default startup data used when first created a startup data file
- F _startup_data.json_ The main data file that holds all the up-to-date startup data used by the _CompStart_ PowerShell script

### Folder: /devenv/config/schema

- F _startup_data.schema.json_ The schema file for the _startup_data_ JSON file that's used for validation
- F _startup_item.schema.json_ The schema file for a specific startup item that's used for validation

#### Folder: /devenv/data

- D _data/misc_data_ - Holds any non-code related files such as text files with planning information, etc.
- D _data/old_data_ - Holds any old or original code files to keep for posterity or just in case

#### Folder: /devenv/data/misc_data

- F _extra_info.txt_ - A text file with some relevant links including questions on Stack Overflow pertinent to this project, JSON Schema validation attempts, and online articles that all had relevance in the early stages of this project
- F _json_schema_update_ideas.txt_ - A text file with ideas for the JSON schema that were already implemented
- F _robswc_suggestions.txt_ - A text file with some project changes and enhancements from Reddit user <a href="https://www.reddit.com/u/robswc">u/robswc</a> that were already implemented
- F _md_examples.md_ - Examples of Markdown language

#### Folder: /devenv/data/old_data

- D _python-tool-testing_ - A folder containing various Python scripts and JSON files all related to various testing done during the creation of the _CompStart_ Python CLI tool
- F _imports_list.txt - A text file listing all the Python import statements that cover all the Python scripts in the _dependencies_ folder
- F _old_startup.ps1_ - The original startup PowerShell script file with all the startup data hard coded in
- F _old_setup.bat_ - A batch file that was going to act as the installer for this program but will be changed into a PowerShell script

#### Folder: /devenv/experimental_content

- See the _Readme_ in this folder for further details

#### Folder: /devenv/features

- See the _Readme_ in this folder for further details

#### Folder: /packages

- See the _Readme_ in this folder for further details

#### Folder: /releases

- See the _Readme_ in this folder for further details
