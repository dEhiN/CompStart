# CompStart Technical Details

<hr>

## Components

The main components of CompStart currently are:

- Batch script (x1)
- PowerShell script (x1)
- JSON config files (x2)
- JSON schema files (x2)
- Python CLI program (x1)

<hr>

## File Details

### Batch Script

#### Name:

_CompStart.bat_

#### Description:

This script starts off the whole process by running _CompStart.ps1_.

A shortcut to _CompStart.bat_ is placed in the Windows Start Menu folder.

### PowerShell Script

#### Name:

_CompStart.ps1_

#### Description:

This script is the core of _CompStart_. This is where the magic happens; where the actual programs are started.

When this script is run, it initially prompts the user whether they want to run _CompStart.ps1_. This allows a user to choose to use this tool or not on every computer startup.

The script itself has 4 sections to it:

- Main loop
- JSON data reading
- Function to process JSON data
- Function to start actual program

The main loop ensures that the user only enters valid responses to the initial prompt. If they decline the prompt, the script quits. If they enter an invalid response, the user is prompted again.

Once the user chooses to continue with the script, the startup data is read from _startup_data.json_. The first function is then called for each startup item.

This first function checks to see if there are any arguments given for the specific startup item (see below). Once that is determined, a correctly formatted string is created and passed to the second function.

The second function does the actual running of the startup program by using the PowerShell cmdlet **Start-Process**.

### JSON Config Files

#### Name:

_startup_data.json_

#### Description:

This is the main JSON file where all the startup information is stored using the format described in the _startup_data.schema.json_ file.

It is sometimes referred to as the user JSON config file or the user startup config file.

As already mentioned, _CompStart.ps1_ reads each startup item from this main JSON file and runs it. Part of the structure of the JSON data allows for arguments to be added to a startup item. This is what allows the user to open a browser window with 3 tabs, or open Microsoft Word with a specific file.

#### Name:

_default_startup.json_

#### Description:

This file contains sample startup JSON data which acts as the default startup data. This default data is used upon install to populate _startup_data.json_.

There are 3 startup items in this file:

- Windows Calculator
- Google Chrome
- Windows Notepad

The second startup item has arguments to go to the Google homepage in a new window using the default profile.

### JSON Schema Files

#### Name:

_startup_data.schema.json_

#### Description

This JSON schema file describes the overall structure of the startup data.

This is used by the Python command-line tool for JSON validation to ensure that the user JSON config file will always be in the necessary JSON format the program expects.

#### Name:

_startup_item.schema.json_

#### Description:

This JSON schema file describes the structure of a single startup item in the startup data.

This is used by the Python command-line tool for JSON validation to ensure that the user JSON config file will always be in the necessary JSON format the program expects.

### Python CLI Program

#### Name:

_CompStart.py_

#### Description:

This Python script was created to allow a user to modify the startup data. 

In the very first release of _Compstart_, the only way to modify the user JSON config file was manually using Notepad. This script and its dependencies were created to function as a CLI - command-line interface - tool to allow users to modify the user startup data through a series of menus and prompts.

The starting point for the tool is _CompStart.py_. The tool uses 9 other Python files which are set up as modules in the _/devenv/dependencies_ folder. Although there are 10 files in total, during the release process, a single executable file is created. This allows for the user to double-click the executable and follow the command-line prompts.

### Name:

_CompStart.exe_

### Description:

As already mentioned, during the release process, _CompStart.py_ and all the modules it depends on are bundled into _CompStart.exe_. This is done using the Python module _PyInstaller_.

_Last Updated: 2026-04-05_
