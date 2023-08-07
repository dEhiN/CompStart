# CompStart/features

Parent folder to store all feature branches while being worked on. Each feature branch will have its own child folder. The folder itself is called *feature_addons*.

## features/bat_installer

Branch to work on the batch installer *setup.bat*. This file is currently the main and/or only installer file as of 2023-08-03. Currently, the file creates the batch file *startup.bat* which is what's called by Windows during startup. This is accomplished through a shortcut that has been manually placed in the Windows local user startup folder. The file *startup.bat* then runs *startup.ps1* to process and do the actual startup actions.

As of 2023-08-03, the only production environment is my work laptop. As a result, the *startup.bat* file found in the project root folder points to the full path of *startup.ps1* as found on my work laptop. However, because *setup.bat* programmatically gets the current script (or working) directory and uses that as the root for all relative paths, *setup.bat* is considered to be in testing and creates a file called *test.bat* instead. This file is stored in the data/test_data folder.

### Status as of 2023-08-06

I've decided to abandon using a batch file as an installer. I'm going to switch to using a PowerShell script since that will give me a lot more flexibility.