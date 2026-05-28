# CompStart/devenv/features

<hr>

## Purpose
Parent folder to hold all feature branches while being worked on.

## Structure

Each active feature branch should have its own subfolder. Additionally, the full branch name should include the parent folder. For example:

* _features/feature-one_

In the case of past feature branches, depending on when the branch was worked on, the parent folder had a different name:

* _feature_addons/_
* _update/_

When listing the branch name below, the full branch name should be used.

<hr>

## Current Branches

There are currently no active feature branches.

<hr>

## Past Branches (newest > oldest)

### 15. features/cs-installer

Created a PowerShell script to automate the installation of _CompStart_. This script creates the _CompStart_ folder and then copies over all files within the subdirectory _installer-files_.

### 14. features/create_release_package

Created a PowerShell script to automate the process of creating a package. This script first checks to see if a package folder for the associated release exists and, if not, creates the folder. The script then creates a ZIP file from the _CompStart_ folder and the _instructions.txt_ file within the release folder.

**(Note: While working on issue #80, the functionality of this script was merged into the new _DeployRelease.ps1_ script. However, since the issue was a bug fix, no new feature branch was created.)**


### 13. features/copy_release_content

Created the third PowerShell script to automate the process of creating a release. This third script creates the directory structure necessary for a release as well as copies over the relevant content. This includes the _CompStart.exe_ file in the _py-tools_ folder. Because of this, the release automation scripts need to be run in the following order:

_CreateReleaseFolder.ps1_ > _GeneratePythonTool.ps1_ > _CopyReleaseContent.ps1_

**(Note: While working on issue #80, the functionality of these 3 scripts was merged into the new _DeployRelease.ps1_ script. However, since the issue was a bug fix, no new feature branch was created.)**

### 12. features/create_new_release

Created a script to automate the creation of a _release_ folder. Note, this feature branch changed scope partway during development. See issue [#64](https://github.com/dEhiN/CompStart/issues/64) for more details. This script asks the user for the _release_ details and then creates the major, minor, and release folder if it doesn't exist. Note also that the PowerShell script created for **features/generate_python_executable** was modified. It doesn't create the _release_ folder anymore. Rather, it checks for the existence of a _release_ folder by still asking the user for the _release_ details. If the folder doesn't exist, the script tells the user to run this new script.

### 11. features/generate_python_executable

Created a script to automate the generation of an executable for the Python command-line tool. Previously, this process was all done manually. The script creates a _release_ folder by asking the user for the _release_ details. It then creates a _py-tools_ folder within the _release_ folder, and copies over _CompStart.py_ along with the whole _dependencies_ folder. Finally, the script calls the Python module _PyInstaller_ to generate the executable from within the _release_ folder. The script firsts check to see if the _py-tools_ folder already has content. If so, it deletes all the files, then performs the copy and calling of _PyInstaller_.

### 10. feature_addons/startup_data_modifier_tool

Developed fully the command-line Python tool for a user to use to create and modify the _startup_data.json_. While the plan is eventually to create a GUI-based tool, to start with, this command line tool was created.

### 9. feature_addons/powershell_installer

Meant for continuation of the PowerShell installer. As written in **features/bat_installer**, after working on a batch script to act as this program's installer and having a lot of difficulty, decided to switch gears and create a PowerShell script instead.

### 8. features/python_tkinter_test

Meant for playing around with the Python GUI library Tkinter. The plan was to decide if this is the library to use when creating the Python tool that will allow the creation and updating of _startup_data.json_. This branch got merged into the two current features branches because for now, the focus is to create a command-line Python tool for creating and updating _startup_data.json_.

### 7. features/json_schema_update

Continued working on the _startup_data.json_ schema file, _startup_data.schema.json_. From a previous feature branch, the basics of the schema has been created, enough that when using an online JSON schema validator, everything validates without any errors. This time, the schema was out more using advanced JSON Schema specs, such as constraints on what keys are required, default values, an example, a title to the schema and a detailed description of the schema and all its keys.

### 6. features/revert-commit_d2514b3dedfcda44c7a259377a0087d25696a8f21

Tried to amend some commit messages but wasn't able to, so decided to detach HEAD at a previous commit. Commit d2514b3 is the commit just before branch **features/bat_installer** is merged into **main**. The commit log and reflog of main will look really crazy, particularly the reflog as multiple attempts were made to rebase, but every time there were issues. Created this branch to push through the commit messages that show when **features/bat_installer** is merged into **main**.

### 5. features/bat_installer

Continued working on the batch installer _setup.bat_. Refactored the code to set up the various file names and relative and absolute paths necessary to create _startup.bat_ and copy all the program files to a folder in the user's local app data folder. Created logic to change the locations of everything and to use the name _test.bat_ while in the testing environment. Realized that using batch or CMD commands to accomplish the task of installing _CompStart_ will be extremely difficult and is probably unnecessary. Decided to utilize a PowerShell script for greater flexibility.

### 4. features/json_schema

Created JSON Schema file _startup_data.schema.json_ to describe the data structure for _startup_data.json_.

### 3. features/setup_startup

Created file _setup.bat_ to act as the "installer" for _CompStart_. Added ability to switch between testing and production environments while working on _setup.bat_. Added ability in _setup.bat_ to programmatically create _startup.bat_ based on current user's local HOMEPATH, etc. While in testing, used the name _test.bat_ instead of _startup.bat_ to not mix things up with the existing setup for the work laptop.

### 2. features/json_file

Started using the root _features/_ for naming branches. Refactored _startup.ps1_ to utilise the _startup_data.json_ rather than having hardcoded startup data.

### 1. update/add_json_file

Created the JSON file _startup_data.json_ to store all the data for the programs to open, such as file path, argument lists, etc. Populated the file with current usage needs for work and decided on JSON data structure. Made changes to which programs and browser tabs opened in _startup.ps1_ based on updated needs at work. Renamed the program from _démarrage_ordinateur_ to _CompStart_.

_Last Updated: 2026-04-06_
