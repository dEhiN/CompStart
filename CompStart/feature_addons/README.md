# CompStart/features

Parent folder to store all feature branches while being worked on. Each feature branch will have its own child folder. The folder itself is called *feature_addons*.


## Current Branches

### features/json_schema_update

Branch created to continue creating the *startup_data.json* schema file, *startup_data.schema.json*. From a previous feature branch, the basics of the schema has been created, enough that when using an online JSON schema validator, everything validates without any errors.

However, I would like to flesh out more of the schema using more advanced JSON Schema specs. I want to add constraints on what keys are required, any default values, etc.


## Past Branches (oldest > newest)
### 1. update/add_json_file

Created the JSON file *startup_data.json* to store all the data for the programs to open, such as file path, argument lists, etc. Populated the file with current usage needs for work and decided on JSON data structure. Made changes to which programs and browser tabs opened in *startup.ps1* based on updated needs at work. Renamed the program from **démarrage_ordinateur** to **CompStart**. At this time, the root *update/* was used for naming branches.

### 2. features/json_file

Started using the root *features/* for naming branches. Refactored *startup.ps1* to utilise the *startup_data.json* rather than having hardcoded startup data.

### 3. features/setup_startup

Created file *setup.bat* to act as the "installer" for **CompStart**. Added ability to switch between testing and production environments while working on *setup.bat*. Added ability in *setup.bat* to programmatically create *startup.bat* based on current user's local HOMEPATH, etc. While in testing, used the name *test.bat* instead of *startup.bat* to not mix things up with the existing setup for the work laptop.

### 4. features/json_schema

Created JSON Schema file *startup_data.schema.json* to describe the data structure for *startup_data.json*. 

### 5. features/bat_installer

Continued working on the batch installer *setup.bat*. Refactored the code to set up the various file names and relative and absolute paths necessary to create *startup.bat* and copy all the program files to a folder in the user's local app data folder. Created logic to change the locations of everything and to use the name *test.bat* while in the testing environment. Realized that using batch or CMD commands to accomplish the task of installing **CompStart** will be extremely difficult and is probably unnecessary. Decided to utilize a PowerShell script for greater flexibility.

### 6. features/revert-commit_d2514b3dedfcda44c7a259377a0087d25696a8f21

Tried to amend some commit messages but wasn't able to, so decided to detach HEAD at a previous commit. Commit d2514b3 is the commit just before branch **features/bat_installer** is merged into **main**. The commit log and reflog of main will look really crazy, particularly the reflog as attempted multiple times to rebase, but every time there were issues. Created this branch to push through the commit messages that show when **features/bat_installer** is merged into **main**.