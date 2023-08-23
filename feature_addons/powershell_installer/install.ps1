# This will be the installation script used for CompStart
<# The code below is from setup.bat in CompStart\data\old_data:
echo OFF

:: Toggle between test and prod environments
set "PROD_ENV=false"
:: Relative path of install files folder
set "SCRIPT_RELPATH=install_files\"
:: Relative path of data folder
set "DATA_RELPATH=install_files\data\"
:: Name of startup PowerShell script
set "POWERSHELLSCRIPT_FILENAME=startup.ps1"

:: Root folder to start work from
:: Filename for startup batch script
:: Filename for startup JSON data file
:: Path to user startup folder
:: Path to user program or app folder
if %PROD_ENV% == true (
    set "SCRIPT_ROOT=%CD%\CompStart\"
    set "BATCHSCRIPT_FILENAME=startup.bat"
    set "STARTJSON_FILENAME=startup_data.json"
    set "STARTFOLDER_FULLPATH=%HOMEDRIVE%%HOMEPATH%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\"
    set "INSTALLFOLDER_RELPATH=%LOCALAPPDATA%\"
) else (
    set "SCRIPT_ROOT=%CD%\CompStart\feature_addons\bat_installer\"
    set "BATCHSCRIPT_FILENAME=CompStart.bat"
    set "STARTJSON_FILENAME=test_data.json"
    set "STARTFOLDER_FULLPATH=%CD%\CompStart\feature_addons\bat_installer\simulation_tests\startup_folder\"
    set "INSTALLFOLDER_RELPATH=simulation_tests\program_files_folder\"
)

:: Full path and name for startup batch script
set "BATCHSCRIPT_FULLPATH=%SCRIPT_ROOT%%SCRIPT_RELPATH%%BATCHSCRIPT_FILENAME%"
:: Full path and name for startup PowerShell script
set "POWERSHELLSCRIPT_FULLPATH=%SCRIPT_ROOT%%SCRIPT_RELPATH%%POWERSHELLSCRIPT_FILENAME%"
:: Full path and name for startup JSON data file
set "STARTJSON_FULLPATH=%SCRIPT_ROOT%%DATA_RELPATH%%STARTJSON_FILENAME%"
:: Startup command to use when creating startup batch script
set "BATCHSCRIPT_CMD=start powershell.exe -ExecutionPolicy Unrestricted -File %POWERSHELLSCRIPT_FULLPATH%"

:: Create startup batch script which will be used to called the startup PowerShell script
echo %BATCHSCRIPT_CMD% > %BATCHSCRIPT_FULLPATH%

cd %SCRIPT_ROOT%%INSTALLFOLDER_RELPATH%

if exists "%CD%\CompStart\nul" (
    echo Already exists
) else (
    mkdir CompStart
)
#>

# Convert this BAT code to PowerShell code
<#
:: Toggle between test and prod environments
set "PROD_ENV=false"
:: Relative path of install files folder
set "SCRIPT_RELPATH=install_files\"
:: Relative path of data folder
set "DATA_RELPATH=install_files\data\"
:: Name of startup PowerShell script
set "POWERSHELLSCRIPT_FILENAME=startup.ps1"
#>
$ProdEnv = $false
$ScriptRelPath = "install_files\"
$DataRelPath = "install_files\data"
