:: Main Batch script for CompStart

:: .SYNOPSIS
REM This batch file sets up the environment and starts the PowerShell script for CompStart.

:: .DESCRIPTION
REM The `CompStart.bat` file sets the path to the current directory, constructs the full path to the PowerShell script `CompStart.ps1`, and then starts the PowerShell script with unrestricted execution policy.

:: .PARAMETER mypath
REM The path to the directory where the batch file is located, taken from the command line.

:: .EXAMPLE
REM To run the batch file, simply execute it from the command line: CompStart.bat

:: .NOTES
REM Author: David H. Watson (with help from VS Code Copilot)
REM GitHub: @dEhiN
REM Date: 2024-12-30

REM Turn off command echoing
@echo off

REM Set the path to the directory where the batch file is located
set mypath=%~dp0

REM Set the name of the PowerShell script to be executed
set scriptname=CompStart.ps1

REM Construct the full path to the PowerShell script
set startupscript=%mypath%%scriptname%

REM Print the full path to the PowerShell script
echo %startupscript%

REM Turn on command echoing
@echo on

REM Start the PowerShell script with unrestricted execution policy
start powershell.exe -ExecutionPolicy Unrestricted -File %startupscript%