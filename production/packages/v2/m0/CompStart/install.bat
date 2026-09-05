:: Batch file to start the PowerShell installer for CompStart

:: .SYNOPSIS
REM This batch file sets up the environment and starts the PowerShell script to install CompStart.

:: .DESCRIPTION
REM The `install.bat` file sets the path to the current directory, constructs the full path to the PowerShell script `install.ps1`, and then starts the PowerShell script with unrestricted execution policy.

:: .PARAMETER mypath
REM The path to the directory where the batch file is located, taken from the command line.

:: .EXAMPLE
REM To run the batch file, simply execute it from the command line: install.bat

:: .NOTES
REM Author: David H. Watson
REM GitHub: @dEhiN
REM Date: 2025-07-05

REM Turn off command echoing
@echo off

REM Set the path to the directory where the batch file is located
set mypath=%~dp0

REM Set the name of the PowerShell script to be executed
set scriptname=install.ps1

REM Construct the full path to the PowerShell script
set startupscript=%mypath%%scriptname%

REM Print the full path to the PowerShell script
echo %startupscript%

REM Turn on command echoing
@echo on

REM Start the PowerShell script with unrestricted execution policy
start powershell.exe -ExecutionPolicy Unrestricted -File %startupscript%