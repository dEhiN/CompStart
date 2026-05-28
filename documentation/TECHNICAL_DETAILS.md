# CompStart Technical Details

The main components of CompStart are:

- Batch script
- PowerShell script
- JSON config files
- JSON schema files
- Python command-line tool

## File Details

### Batch script

#### Name:

_CompStart.bat_

#### Description:

This script starts off the whole process. A shortcut to _CompStart.bat_ is placed in the Windows Start Menu folder. The script itself starts _CompStart.ps1_.

### PowerShell script

#### Name:

_CompStart.ps1_

#### Description:

This script is the core of the tool. This is where the magic happens, where the actual programs are started. However, first the user is prompted whether they want to run _CompStart.ps1_. This allows a user to start their computer without having all their startup programs run.

The script itself consists of a main loop and two functions. The main loop ensures that the user only enters valid responses to the prompt. If they decline the prompt, the script quits. Otherwise, after reading in _startup_data.json_, the first function is called for each startup item. This function checks to see if there are any arguments given for the specific startup item. The second function is then called to actually start the program by using the PowerShell cmdlet **Start-Process**.

### JSON config files

#### Name:

_startup_data.json_

#### Description:

This is the main JSON file where all the startup information is stored using the format described in the _startup_data.schema.json_ file. As already mentioned, _CompStart.ps1_ reads each startup item from this file and runs it. Part of the structure of the JSON data allows for arguments to be added for a startup item. This is what allows the user to open a browser window with 3 tabs, or open Microsoft Word with a specific file.

#### Name:

_default_startup.json_

#### Description:

This file contains example JSON startup data which acts as the default startup data. This default data is used upon install.

There are 3 startup items in this file:

- Windows Calculator
- Google Chrome
- Windows Notepad

The second startup item has arguments to open Chrome using the default profile, to open a new window, and to go to the Google homepage.

This file was created initially because the user had to manually edit _startup_data_.json* in the first release. While there were instructions on how to do that, \_default_startup.json* allowed users to see how the startup data was structured. This also ensured that when the user runs the tool upon installation, there are items to open.

### JSON schema files

#### Name:

_startup_data.schema.json_

#### Description

This JSON schema file describes the structure of the _startup_data.json_ file. It is found in the _/devenv/config_ folder.

#### Name:

_startup_item.schema.json_

#### Description:

This JSON schema file describes the structure of a single startup item in the _startup_data.json_ file. It is also found in the _/devenv/config/schema_ folder.

### Python command-line tool

#### Name:

_CompStart.py_

#### Description:

This tool, or Python script, was created to allow a user to modify the _startup_data.json_ file. While the tool is command-line only, and therefore not as friendly as a graphical tool, it is a step up from manual modification.

The starting point for the tool is _CompStart.py_. While that's the starting point, the tool uses 9 other Python files which are set up as modules in the _/devenv/dependencies_ folder. Although there are 10 files in total, during the release process, a single executable file is created. This allows for the user to double-click the executable and follow the command-line prompts.

### Name:

_CompStart.exe_

### Description:

As already mentioned, during the release process, _CompStart.py_ and all the modules it depends on are bundled into _CompStart.exe_. This is done using the Python module **PyInstaller**.

_Last Updated: 2025-04-27_
