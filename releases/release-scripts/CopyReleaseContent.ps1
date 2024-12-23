# PowerShell script to copy over the relevant content for creating a new release. This script will create the release directory structure and copy over all the files that will be needed for the release with two exceptions. The first is that the script will assume the release folder exists. The second is that the Python CLI tool executable will assume to exist and will be copied over as part of the release content.

# Set the sleep time as a global variable
$Global:SleepTime = 2

# Import the Set-StartDirectory function
Import-Module ".\SetStartDirectory.psm1"

# Set the starting directory to the project root
$SetCSSuccess = Set-StartDirectory "CompStart"

# Get the location of the release folder root
$ProjectRootPath = Get-Location

# Check to make sure we are in the project root
if (-Not $SetCSSuccess) {
    # Inform user project root can't be found and the script is ending
    Write-Host "`nUnable to find project root. Quitting script..."
    Exit
}

# Initialize the devenv file and folder names to be used in the script
$DevFolder = "devenv"
$ConfigFolder = "config"
$CompStartFolder = "CompStart"
$PowerShellScriptFile = "CompStart.ps1"
$BatchScriptFile = "CompStart.bat"

# Create the devenv paths to be used in the script
$DevPath = "$ProjectRootPath\$DevFolder"
$ConfigPath = "$DevPath\$ConfigFolder"
$CSFolderPath = ""
$CSPowerShellPath = "$DevPath\$PowerShellScriptFile"
$CSBatchPath = "$DevPath\$BatchScriptFile"

# Initialize the release file and folder names to be used in the script
$ReleasesFolder = "releases"
$ReleaseVersionsFolder = "release-versions"
$ReleaseTemplatesFolder = "release-templates"
$ReleaseNotesFolder = "release-notes"
$ReleaseNotesMDFile = "release_notes.md"
$ReleaseInstructionsFile = "instructions.txt"
$FullReleaseVersion = ""

# Create the release paths to be used in the script
$ReleasesPath = "$ProjectRootPath\$ReleasesFolder"
$ReleaseVersionsPath = "$ReleasesPath\$ReleaseVersionsFolder"
$ReleaseTemplatesPath = "$ReleasesPath\$ReleaseTemplatesFolder"
$ReleaseNotesFolderPath = ""
$ReleaseNotesMDPath = "$ReleaseTemplatesPath\$ReleaseNotesMDFile"
$ReleaseInstructionsPath = "$ReleaseTemplatesPath\$ReleaseInstructionsFile"

# Create the PyInstaller specific variables to be used in the script
$PyToolsFolder = "py-tools"
$PyIDistFolder = "dist"
$PythonExeFile = "CompStart.exe"
$PyToolsPath = ""
$PyIDistPath = ""
$CSPythonPath = ""

# Determine which version number we are working with
Write-Host "`nWhat is the release major version number? " -NoNewline
$ReleaseMajorVersion = $Host.UI.ReadLine()

Write-Host "What is the release minor version number? " -NoNewline
$ReleaseMinorVersion = $Host.UI.ReadLine()

Write-Host "What is the release tag for v$ReleaseMajorVersion.$ReleaseMinorVersion (or leave blank if there is none)? " -NoNewline
$ReleaseTag = $Host.UI.ReadLine()

$FullReleaseVersion = "$ReleaseMajorVersion.$ReleaseMinorVersion"

# Add the release tag if one exists
if ($ReleaseTag -ne "") {
    $FullReleaseVersion += "-$ReleaseTag"
}

# Determine the full path to the release directory we are working with
$FullReleasePath = "$ReleaseVersionsPath\v$ReleaseMajorVersion\m$ReleaseMinorVersion\$FullReleaseVersion"

# Before proceeding, confirm the release folder path exists and if not, alert the user to create it
if (-Not (Test-Path $FullReleasePath)) {
    Write-Host "`nThe release folder $FullReleasePath does not exist!`nPlease run the PowerShell script 'CreateReleaseFolder.ps1' before running this script..."
    Exit
}

Set-Location $FullReleasePath

# Create the CompStart folder for the release, if needed, and update the appropriate path variable
if (-Not (Test-Path $CompStartFolder)) {
    Write-Host "`nCreating the CompStart folder for release $FullReleaseVersion..."
    Start-Sleep $Global:SleepTime
    New-Item -ItemType Directory -Name $CompStartFolder > $null
}
else {
    Write-Host "`nThere already exists a CompStart folder for release $FullReleaseVersion...skipping this step..."
    Start-Sleep $Global:SleepTime
}
$CSFolderPath = "$FullReleasePath\$CompStartFolder"

# Create the release notes folder for the release, if needed, and update the appropriate path variable
if (-Not (Test-Path $ReleaseNotesFolder)) {
    Write-Host "`nCreating the release-notes folder for release $FullReleaseVersion..."
    Start-Sleep $Global:SleepTime
    New-Item -ItemType Directory -Name $ReleaseNotesFolder > $null
}
else {
    Write-Host "`nThere already exists a release-notes folder for release $FullReleaseVersion...skipping this step..."
    Start-Sleep $Global:SleepTime
}
$ReleaseNotesFolderPath = "$FullReleasePath\$ReleaseNotesFolder"

# Copy the CompStart content
Write-Host "`nPopulating the CompStart folder for release $FullReleaseVersion..."
Start-Sleep $Global:SleepTime
Copy-Item -Path $CSBatchPath -Destination $CSFolderPath
Copy-Item -Path $CSPowerShellPath -Destination $CSFolderPath
Copy-Item -Path $ConfigPath -Destination $CSFolderPath -Recurse -Force

# Copy the release notes content and instructions file
Write-Host "`nCopying over the instructions and release notes README for release $FullReleaseVersion..."
Start-Sleep $Global:SleepTime
Copy-Item -Path $ReleaseNotesMDPath -Destination $ReleaseNotesFolderPath
Copy-Item -Path $ReleaseInstructionsPath -Destination $FullReleasesPath

# Deal with the Python executable
$PyToolsPath = "$FullReleasePath\$PyToolsFolder"
if (-Not (Test-Path $PyToolsPath)) {
    Write-Host "`nUnable to find a py-tools folder.`nPlease run the PowerShell script `GeneratePythonTool.ps1` before running this script..."
    Exit
}
$PyIDistPath = "$PyToolsPath\$PyIDistFolder"
$CSPythonPath = "$PyIDistPath\$PythonExeFile"
Write-Host "`nCopying over the Python tool executable for release $FullReleaseVersion..."
Start-Sleep $Global:SleepTime
Copy-Item -Path $CSPythonPath -Destination $CSFolderPath


# Change the working directory back to the project root
Write-Host "`nAll release content has been copied over successfully to $FullReleasePath"
Write-Host "Changing directory back to project root"
Set-Location $ProjectRootPath