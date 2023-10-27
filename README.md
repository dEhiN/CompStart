# Demord

## Purpose

Demord is a program that allows you to choose which programs open automatically when your computer starts. This is different from using the built-in Windows functionality to control startup items, such as through Task Manager or using the startup folders. This program will let you set up specific tabs and browser windows including web apps (i.e., Chrome apps) in addition to installed programs. For example, the program could open up a specific Word document as well as 2 different Chrome windows with the first one showing 3 tabs and the second one showing 2 tabs.

This is done using a JSON config file and a Powershell script. There is also a Batch file that starts off the whole process. This Batch file starts off the whole process. The idea will be that the Batch file will be put into the Windows Start Menu folder, and it will run the Powershell script. The Batch file is interactive, and first asks the user if they want to run the script. This ensures that a user could start their computer without having all their startup programs run whenever they want.

Currently, as of 2023-10-27, the Powershell script and Batch file both work and I use them at work. However, the JSON file has to be manually adjusted but there is a JSON Schema file that can be used. There is a feature branch for creating a command-line tool written in Python to allow the creation, viewing and editing of the JSON file. Currently, the tool can create a new JSON file with some default startup data and view the existing startup data. It can also edit existing startup items, but can't save the changes. There is another feathre branch to create an installer in Powershell. There are 2 README files, this one, and one in the <code>feature_addons folder</code>, which is where all the feature branches are held. That README lists all the past feature branches as well as the current ones.
<br>
<br>

## Files and Folders

### Folders
* *data* - The main data folder consisting of subfolders and data files.
* *data/json_data* - Holds all the various JSON files for configuration, startup data, etc. including JSON files used for testing
* *data/misc_data* - Holds any non-code related files such as text files with planning information, etc.
* *data/old_data* - Holds any old or original code files that I want to keep for posterity or just in case
* *feature_addons* - Parent folder to hold child folders for each feature branch being worked on (see README inside that folder for more information)


### Files
#### within folder: */*
* *startup.ps1* - The main PowerShell script that sets up all the programs, browser windows, and tabs
* *startup.bat* - A batch file that is run on Windows start and calls *startup.ps1*
* *README.md* - This README
* *.gitignore* - The gitignore file for this project
#### within folder: *data/json_data*
* *startup_data.json* - The startup data that *startup.ps1* reads and will store all the programs and websites to open along with any parameters to pass in, etc
* *startup_data.schema.json* - A JSON Schema file for *startup_data.json*
* *test_data.json* - A simple startup data file that only opens Notepad and was used in testing the *startup.ps1* script to make sure it worked
#### within folder: *data/misc_data*
* *extra_info.txt* - A text file with some relevant links including questions on Stack Overflow pertinent to this project, JSON Schema validation attempts, and online articles that have relevance
* *json_schema_update_ideas.txt* - A text file with ideas to implement in the JSON schema
* *robswc_suggestions.txt* - A text file with some project changes and enhancements from Reddit user robswc
* *md_examples.md* - Examples of Markdown language
#### within folder: *data/old_data*
* *old_startup.ps1* - The original startup PowerShell script file with all the startup data hard coded in
* *old_setup.bat* - A batch file that was going to act as the installer for this program but will be changed into a PowerShell script
