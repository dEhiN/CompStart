# CompStart
CompStart is a program that allows you to choose which programs open automatically when your computer starts. This is different from using the built-in Windows functionality to control startup items, such as through Task Manager or using the startup folders. CompStart will let you set up specific tabs and browser windows including web apps (i.e., Chrome apps) in addition to installed programs.
<br>
<br>
## Files and Folders
*startup.ps1* - The main PowerShell script that sets up all the programs, browser windows, and tabs.<br>
*startup.bat* - A batch file that is run on Windows start and calls *startup.ps1*.<br>
*setup.bat* - A batch file that will act as the installer for this program.<br>
*data* - The main data folder consisting of subfolders and data files.<br>
*data/json_data* - Holds all the various JSON files for configuration, startup data, etc.<br>
*data/json_data/startup_data.json* - The startup data that *startup.ps1* reads and will store all the programs and websites to open along with any parameters to pass in, etc.<br>
*data/json_data/startup_data.schema.json* - A JSON Schema file for *startup_data.json*.<br>
