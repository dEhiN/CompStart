:: Batch file to automatically call the 3 PowerShell scripts needed for automating a release

echo off

set currpath=%~dp0
set scriptone=CreateReleaseFolder.ps1
set scripttwo=GeneratePythonTool.ps1
set scriptthree=CopyReleaseContent.ps1

echo.
echo Running CreateReleaseFolder.ps1...
start /wait /b powershell.exe -ExecutionPolicy Unrestricted -File %currpath%%scriptone%

echo.
echo Running GeneratePythonTool.ps1...
start /wait /b powershell.exe -ExecutionPolicy Unrestricted -File %currpath%%scripttwo%

echo.
echo Running CopyReleaseContents.ps1...
start /wait /b powershell.exe -ExecutionPolicy Unrestricted -File %currpath%%scriptthree%