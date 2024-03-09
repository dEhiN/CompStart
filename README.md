# Demord

## Purpose

Demord is a tool that allows you to have programs open automatically when your computer starts. But doesn't Windows already allow that through Task Manager and the startup folders, you ask? Well, here's how Demord is different: you can open up specific tabs and browser windows alongside the installed programs. For example, you could open up a specific Word document, a Chrome window with 3 tabs, and the Google Chat Chrome app, all instantaneously after you log in.

Demord will also allow you to quickly and easily* change the programs and sites you want to open. Using the previous example, let's say you finished working on the Word document. You can easily remove that from the startup list, so Demord will only open the Chrome window with 3 tabs and the Google Chat Chrome app.

_*The functionality to modify the list of startup programs isn't ready yet, see below for more details..._
<br>
<br>

## Installation

### For non-devs

Currently, the installation process is manual. If you want to use this tool for yourself, you will need to be comfortable with using the command line, editing the Windows startup folder, and changing JSON configuration files manually. See the releases section (coming soon) to find the files to download. There will be setup instructions included. Follow them and you can start using Demord yourself!

### For devs

The installation instructions are essentially the same as above if you just want to use the tool. However, if you want to install Demord to work on it, depending on what you want to do, you have 2 options:

1. If you want to contribute to this program, read the <strong>How to help</strong> section first. Once you get in touch with me, let me know what you want to do, and I can add you as a contributor to the repository.

2. If you want to play around with what I've created on your own, you can fork this repository. I encourage you to read the <strong>How to help</strong> section. I also ask that if you publish anything you create based on this project, please credit me as applicable. Finally, it would be nice if you let me know.
<br>

## How to help

### First Steps

If you'd like to contribute to this program, please get in touch! On my GitHub profile page, you'll find how to reach me. My profile page is: https://github.com/dEhiN.

Next, read through the following sections:

1. <strong>Technical Details</strong>
2. <strong>Listing of Files and Folders</strong>

Then, read through the README in the <code>feature_addons</code> folder to get an understanding of the current branches being worked on.

Finally, check out the project board at https://github.com/users/dEhiN/projects/4, and familiarize yourself with the open issues and work.

All work I've contributed is well documented and my commits are pretty detailed. However, if there's something you're not sure about, you can always connect with me.

### Technical Details

Demord consists of a Batch file, a PowerShell script, and a JSON config file. The Batch file starts off the whole process. The idea will be to put the Batch file into the Windows Start Menu folder, and it will run the Powershell script. The Batch file is interactive, and first asks the user if they want to run the script. This ensures that a user could start their computer without having all their startup programs run whenever they want.

Currently, as of 2023-10-27, the Powershell script and Batch file both work and I use them on my work laptop. However, the JSON file has to be manually created or updated. There is a JSON Schema file that can be used to know how the JSON file data should be structured.

There is a feature branch for creating a command-line tool that will allow for the creation, viewing, and updating of the JSON file. The tool is being written in Python. There is another feature branch to create an installer in Powershell. There are 2 README files, this one, and one in the <code>feature_addons folder</code>, which is where all the feature branches are held. That README contains detailed information on present and past feature branches.

### Listing of Files and Folders

#### Folders

- _data_ - The main data folder consisting of subfolders and data files.
- _data/json_data_ - Holds all the various JSON files for configuration, startup data, etc. including JSON files used for testing
- _data/misc_data_ - Holds any non-code related files such as text files with planning information, etc.
- _data/old_data_ - Holds any old or original code files that I want to keep for posterity or just in case
- _feature_addons_ - Parent folder to hold child folders for each feature branch being worked on (see README inside that folder for more information)

#### Files

##### within folder: _/_

- _startup.ps1_ - The main PowerShell script that sets up all the programs, browser windows, and tabs
- _startup.bat_ - A batch file that is run on Windows start and calls _startup.ps1_
- _README.md_ - This README
- _.gitignore_ - The gitignore file for this project

##### within folder: _data/json_data_

- _startup_data.json_ - The startup data that _startup.ps1_ reads and will store all the programs and websites to open along with any parameters to pass in, etc
- _startup_data.schema.json_ - A JSON Schema file for _startup_data.json_
- _test_data.json_ - A simple startup data file that only opens Notepad and was used in testing the _startup.ps1_ script to make sure it worked

##### within folder: _data/misc_data_

- _extra_info.txt_ - A text file with some relevant links including questions on Stack Overflow pertinent to this project, JSON Schema validation attempts, and online articles that have relevance
- _json_schema_update_ideas.txt_ - A text file with ideas to implement in the JSON schema
- _robswc_suggestions.txt_ - A text file with some project changes and enhancements from Reddit user <a href="https://www.reddit.com/u/robswc">u/robswc</a>
- _md_examples.md_ - Examples of Markdown language

##### within folder: _data/old_data_

- _old_startup.ps1_ - The original startup PowerShell script file with all the startup data hard coded in
- _old_setup.bat_ - A batch file that was going to act as the installer for this program but will be changed into a PowerShell script
