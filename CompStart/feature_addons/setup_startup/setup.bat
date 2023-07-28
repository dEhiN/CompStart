echo OFF

:: Store path to user startup folder
set STARTFOLDER_RELPATH=\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup
set STARTFOLDER_FULLPATH="%HOMEDRIVE%%HOMEPATH%%STARTFOLDER_RELPATH%"

:: Store startup command to use when creating startup.bat
set BATCHSTART_CMD=start powershell.exe -ExecutionPolicy Unrestricted -File %CD%\startup.ps1

:: Store path and filename for startup.bat
set BATCHSTART_FILEPATH=%CD%\CompStart\feature_addons\setup_startup\
set BATCHSTART_FILENAME=test.bat
set BATCHSTART_FILEPATHNAME=%BATCHSTART_FILEPATH%%BATCHSTART_FILENAME%
:: NEED TO CHANGE BATCHSTART_FILENAME FROM test.bat TO startup.bat FOR PRODUCTION

:: Testing to confirm variables are correct
::echo STARTFOLDER_RELPATH: %STARTFOLDER_RELPATH%
::echo STARTFOLDER_FULLPATH: %STARTFOLDER_FULLPATH%
::echo BATCHSTART_FILEPATH: %BATCHSTART_FILEPATH%
::echo BATCHSTART_CMD: %BATCHSTART_CMD%
::echo BATCHSTART_FILENAME: %BATCHSTART_FILENAME%
::echo BATCHSTART_FILEPATHNAME: %BATCHSTART_FILEPATHNAME%

:: Create startup.bat which will be used to called the startup.ps1 PowerShell script
echo %BATCHSTART_CMD% > %BATCHSTART_FILEPATHNAME%