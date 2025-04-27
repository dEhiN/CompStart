# CompStart Technical Details

#### Technical Details

CompStart consists of a Batch script, a PowerShell script, and a JSON config file.

The Batch script starts off the whole process. A shortcut to the Batch script is placed in the Windows Start Menu folder. The Batch script itself interactively starts the PowerShell script. It's interactive because the user is prompted if they want to run the PowerShell script. This ensures that a user could start their computer without having all their startup programs run.

The JSON config file is where all the startup information is stored. In the _devenv/config_ folder, you'll find a _schema_ subfolder. That contains JSON schema files for the config file. There's one for the full JSON configuration structure and one for a single startup item. The relevant one here is the first schema for the full configuration structure.

The PowerShell script is the core of the tool. This is where the magic happens. The script reads the JSON config file and runs each startup item. In the JSON config structure, there's the ability to add arguments for each startup item. The PowerShell script takes these arguments into account when starting each item. This is what allows the user to open a browser window with 3 tabs, or open Microsoft Word with a specific file.
