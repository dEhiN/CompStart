# CompStart

## Purpose

CompStart is a program that allows you to choose which programs open automatically when your computer starts. This is different from using the built-in Windows functionality to control startup items, such as through Task Manager or using the startup folders. CompStart will let you set up specific tabs and browser windows including web apps (i.e., Chrome apps) in addition to installed programs.
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
#### within folder: *data/json_data*
* *startup_data.json* - The startup data that *startup.ps1* reads and will store all the programs and websites to open along with any parameters to pass in, etc
* *startup_data.schema.json* - A JSON Schema file for *startup_data.json*
* *test_data.json* - A simple startup data file that only opens Notepad and was used in testing the *startup.ps1* script to make sure it worked
#### within folder: *data/misc_data*
* *extra_info.txt* - A text file with some relevant links including questions on Stack Overflow pertinent to this project, JSON Schema validation attempts, and online articles that have relevance
* *json_schema_update_ideas.txt* - A text file with ideas to implement in the JSON schema
* *robswc_suggestions.txt* - A text file with some project changes and enhancements from Reddit user robswc
#### within folder: *data/old_data*
* *old_startup.ps1* - The original startup PowerShell script file with all the startup data hard coded in
* *old_setup.bat* - A batch file that was going to act as the installer for this program but will be changed into a PowerShell script