# CompStart

## Purpose

CompStart is a tool that allows you to have programs open automatically when your computer starts. It currently only works on Windows. But doesn't Windows already allow that through Task Manager and the startup folders, you ask? Well, here's how CompStart is different: you can open up specific tabs and browser windows alongside the installed programs. For example, you could open up a specific Word document, a Chrome window with 3 tabs, and the Google Chat Chrome app, all instantaneously after you log in.

CompStart will also allow you to quickly and easily\* change the programs and sites you want to open. Using the previous example, let's say you finished working on the Word document. You can easily remove that from the startup list, so CompStart will only open the Chrome window with 3 tabs and the Google Chat Chrome app.

_\*The functionality to modify the list of startup programs isn't ready yet, see below for more details..._
<br>
<br>

## Installation

### For non-devs

Currently, the installation process is manual. If you want to use this tool for yourself, you will need to be comfortable with using the command line, editing the Windows startup folder, and changing JSON configuration files manually. See the [releases](https://github.com/dEhiN/CompStart/releases) section to find the files to download. There will be setup instructions included. Follow them and you can start using CompStart for yourself!

### For devs

The installation instructions are essentially the same as above if you just want to use the tool. However, if you want to install CompStart to work on it, depending on what you want to do, you have 2 options:

1. If you want to contribute to this program, read the **How to help** section first. Once you get in touch with me, let me know what you want to do, and I can add you as a contributor to the repository.

2. If you want to play around with what I've created on your own, you can fork this repository. I encourage you to read the **How to help** section. I also ask that if you publish anything you create based on this project, please credit me as applicable. Finally, it would be nice if you let me know.
<br>

## How to help

### First Steps

If you'd like to contribute to this program, please get in touch! On my GitHub profile page, you'll find how to reach me. My profile page is: https://github.com/dEhiN.

Next, read through the following sections:

1. **Technical Details**
2. **Listing of Files and Folders**

Then, read through the README in the <code>feature_addons</code> folder to get an understanding of the current branches being worked on.

Finally, check out the project board at https://github.com/users/dEhiN/projects/4, and familiarize yourself with the open issues and work.

All work I've contributed is well documented and my commits are pretty detailed. However, if there's something you're not sure about, you can always connect with me.

### Technical Details

CompStart consists of a Batch file, a PowerShell script, and a JSON config file. The Batch file starts off the whole process. A shortcut to the Batch file will be put into the Windows Start Menu folder, and it will run the Powershell script. The Batch file is interactive, and first asks the user if they want to run the script. This ensures that a user could start their computer without having all their startup programs run whenever they want.

Currently, as of 2023-10-27, the Powershell script and Batch file both work and I use them on my work laptop. However, the JSON file has to be manually created or updated. There is a JSON Schema file that can be used to know how the JSON file data should be structured. Additionally, as of 2024-03-10, the JSON file being used comes with some default data, namely to open up Windows Calculator, Windows Notepad, and Google Chrome with 3 tabs - Google, Facebook, and X (formerly Twitter).

There is a feature branch for creating a command-line tool that will allow for the creation, viewing, and updating of the JSON file. The tool is being written in Python. There is another feature branch to create an installer in Powershell. There are 2 README files, this one, and one in the <code>feature_addons folder</code>, which is where all the feature branches are held. That README contains detailed information on present and past feature branches.

### Listing of Directories (Folders) and Files

##### Legend

- D = Directory (Folder)
- F = File

#### Folder: root (/)

- D _devenv_: All files related to development
- D _packages_ Package files for each release, as either ZIP or MSI files
- D _releases_ Files related to each official release; this will NOT be the package files but all content that needs to go into a package file
- F _README.md_ - This README
- F _.gitignore_ - The gitignore file for this project

#### Folder: /devenv

- D _data_ - Main data folder consisting of subfolders and data files
- D _feature_addons_ - Parent folder to hold child folders for each feature branch being worked on (see README inside that folder for more information)
- F _startup.ps1_ - Main PowerShell script that sets up all the programs, browser windows, and tabs
- F _startup.bat_ - A batch file that is run on Windows startup and calls _startup.ps1_

#### Folder: /devenv/data

- D _data/json_data_ - Holds all the various JSON files for configuration, startup data, etc. including JSON files used for testing
- D _data/misc_data_ - Holds any non-code related files such as text files with planning information, etc.
- D _data/old_data_ - Holds any old or original code files that I want to keep for posterity or just in case

#### Folder: /devenv/data/json_data

- F _startup_data.json_ - The startup data that _startup.ps1_ reads and will store all the programs and websites to open along with any parameters to pass in, etc
- F _startup_data.schema.json_ - A JSON Schema file for _startup_data.json_
- F _test_data.json_ - A simple startup data file that only opens Notepad and was used in testing the _startup.ps1_ script to make sure it worked

#### Folder: /devenv/data/misc_data

- F _extra_info.txt_ - A text file with some relevant links including questions on Stack Overflow pertinent to this project, JSON Schema validation attempts, and online articles that have relevance
- F _json_schema_update_ideas.txt_ - A text file with ideas to implement in the JSON schema
- F _robswc_suggestions.txt_ - A text file with some project changes and enhancements from Reddit user <a href="https://www.reddit.com/u/robswc">u/robswc</a>
- F _md_examples.md_ - Examples of Markdown language

#### Folder: /devenv/data/old_data

- F _old_startup.ps1_ - The original startup PowerShell script file with all the startup data hard coded in
- F _old_setup.bat_ - A batch file that was going to act as the installer for this program but will be changed into a PowerShell script

#### Folder: /devenv/feature_addons

- F _README.md_ The README for all feature branches containing specific information about past and current branches
- D _\<feature-branch-name>_ One or more folders for each current feature branch

#### Folder: /packages

- D _v\<num>_ A folder for each major version number; for example _v1_ will hold all content related to all version 1 packages

#### Folder: /packages/v\<num>

- D _m\<num>_ A folder for each minor version number; for example _v1/m1_ will all hold all content related to version 1.1 packages

#### Folder: /releases

- D _v\<num>_ A folder for each major version number; for example _v1_ will hold all content related to all version 1 releases
- F _instructions.txt_ Text instructions on how to manually install Demord; will be used and copied to each release until an automated install method is created
- F _README.md_ The README for release information, how it works, etc.
