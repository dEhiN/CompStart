# CompStart/feature_addons

Parent folder to store all feature branches while being worked on. The folder itself is called _feature_addons_.

## Directory Structure

Each feature branch currently active will have its own subfolder within this parent folder. In the case of past branches, depending on when the branch was worked on, this parent folder may have had a different name.

Due to that, the branch name will be listed with what the parent folder was called at the time. Additionally, to keep consistency, the current branches will also include the parent folder.

## Current Branches

### 1. features/create_new_release

Branch meant for creating a script to automate the process involved in new releases. As shared on GitHub, under issue [#64](https://github.com/dEhiN/CompStart/issues/64) for this project, the purpose will be to have 1 or more scripts that, when run, will create a new release folder (if it doesn't already exist), copy over all relevant data from `/devenv` and `/releases/release-templates`, as well as generate the `CompStart.py` Python executable.

## Past Branches (oldest > newest)

### 1. update/add_json_file

Created the JSON file _startup_data.json_ to store all the data for the programs to open, such as file path, argument lists, etc. Populated the file with current usage needs for work and decided on JSON data structure. Made changes to which programs and browser tabs opened in _startup.ps1_ based on updated needs at work. Renamed the program from **démarrage_ordinateur** to **CompStart**. At this time, the root _update/_ was used for naming branches.

### 2. features/json_file

Started using the root _features/_ for naming branches. Refactored _startup.ps1_ to utilise the _startup_data.json_ rather than having hardcoded startup data.

### 3. features/setup_startup

Created file _setup.bat_ to act as the "installer" for **CompStart**. Added ability to switch between testing and production environments while working on _setup.bat_. Added ability in _setup.bat_ to programmatically create _startup.bat_ based on current user's local HOMEPATH, etc. While in testing, used the name _test.bat_ instead of _startup.bat_ to not mix things up with the existing setup for the work laptop.

### 4. features/json_schema

Created JSON Schema file _startup_data.schema.json_ to describe the data structure for _startup_data.json_.

### 5. features/bat_installer

Continued working on the batch installer _setup.bat_. Refactored the code to set up the various file names and relative and absolute paths necessary to create _startup.bat_ and copy all the program files to a folder in the user's local app data folder. Created logic to change the locations of everything and to use the name _test.bat_ while in the testing environment. Realized that using batch or CMD commands to accomplish the task of installing **CompStart** will be extremely difficult and is probably unnecessary. Decided to utilize a PowerShell script for greater flexibility.

### 6. features/revert-commit_d2514b3dedfcda44c7a259377a0087d25696a8f21

Tried to amend some commit messages but wasn't able to, so decided to detach HEAD at a previous commit. Commit d2514b3 is the commit just before branch **features/bat_installer** is merged into **main**. The commit log and reflog of main will look really crazy, particularly the reflog as attempted multiple times to rebase, but every time there were issues. Created this branch to push through the commit messages that show when **features/bat_installer** is merged into **main**.

### 7. features/json_schema_update

Continued working on the _startup_data.json_ schema file, _startup_data.schema.json_. From a previous feature branch, the basics of the schema has been created, enough that when using an online JSON schema validator, everything validates without any errors. This time, the schema was out more using advanced JSON Schema specs, such as constraints on what keys are required, default values, an example, a title to the schema and a detailed description of the schema and all its keys.

### 8. features/python_tkinter_test

Meant for playing around with the Python GUI library Tkinter. The plan was to decide if this is the library to use when creating the Python tool that will allow the creation and updating of _startup_data.json_. This branch got merged into the two current features branches because for now, the focus is to create a command-line Python tool for creating and updating _startup_data.json_.

### 9. feature_addons/powershell_installer

Meant for continuation of the PowerShell installer. As written in **features/bat_installer**, after working on a batch script to act as this program's installer and having a lot of difficulty, decided to switch gears and create a PowerShell script instead.

### 10. feature_addons/startup_data_modifier_tool

Developed fully the command-line Python tool for a user to use to create and modify the _startup_data.json_. While the plan is eventually to create a GUI-based tool, to start with, this command line tool was created.

### 11. features/generate_python_executable

Branch meant for creating a script to automate the generation of an executable for the Python command-line tool. Previously, this process was all done manually. The script creates a _release_ folder by asking the user for the _release_ details. It then creates a `py-tools` folder within the _release_ folder, and copies over `CompStart.py` along with the whole `dependencies` folder. Finally, the script calls the Python module _PyInstaller_ to generate the executable from within the _release_ folder. The script firsts check for to see if the `py-tools` folder already has content. If so, it deletes all the files, then performs the copy and calling of _PyInstaller_.
