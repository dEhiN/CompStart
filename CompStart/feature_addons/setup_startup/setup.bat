echo OFF

:: Store path to user startup folder
set START_PATH=\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup
set FULL_PATH="%HOMEDRIVE%%HOMEPATH%%START_PATH%"

:: Store startup command to use when creating startup.bat
set STARTUP_CMD=start powershell.exe -ExecutionPolicy Unrestricted -File %CD%\startup.ps1

:: Create startup.bat which will be used to called the startup.ps1 PowerShell script
echo %STARTUP_CMD% > test.bat
REM NEED TO CHANGE THE NAME FROM test.bat TO startup.bat FOR PRODUCTION