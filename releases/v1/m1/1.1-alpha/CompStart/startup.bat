:: Main Batch script for CompStart
echo off
set mypath=%~dp0
set scriptname=startup.ps1
set startupscript=%mypath%%scriptname%
echo %startupscript%
echo on
start powershell.exe -ExecutionPolicy Unrestricted -File %startupscript% 