# PowerShell script to copy over the relevant content for creating a new release. This script will create the release directory structure and copy over all the files that will be needed for the release with two exceptions. The first is that the script will assume the release folder exists. The second is that the py-tools folder will not be created nor will the Python CLI tool executable be dealt with.

# Get the location of the release folder root
$ProjectRootPath = Get-Location

# Check to make sure we are in the project root
if (-Not (Select-String -InputObject $ProjectRootPath -Pattern "CompStart" -CaseSensitive)) {
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
$ConfigPath = "$DevFolder\$ConfigFolder"
$CSFolderPath = ""
$CSPowerShellPath = "$DevFolder\$PowerShellScriptFile"
$CSBatchPath = "$DevFolder\$BatchScriptFile"

# Initialize the release file and folder names to be used in the script
$ReleasesFolder = "releases"
$ReleaseVersionsFolder = "release-versions"
$ReleaseTemplatesFolder = "release-templates"
$ReleaseNotesFolder = "release-notes"
$ReleaseNotesMDFile = "release_notes.md"
$ReleaseInstructionsFile = "instructions.txt"

# Create the release paths to be used in the script
$ReleasesPath = "$ProjectRootPath\$ReleasesFolder"
$ReleaseVersionsPath = "$ReleasesPath\$ReleaseVersionsFolder"
$ReleaseTemplatesPath = "$ReleasesPath\$ReleaseTemplatesFolder"
$ReleaseNotesFolderPath = ""
$ReleaseNotesMDPath = "$ReleasesTemplatesPath\$ReleaseNotesMDFile"
$ReleaseInstructionsPath = "$ReleasesTemplatePath\$ReleaseInstructionsFile"

# Determine which version number we are working with
Write-Host "`nWhat is the release major version number? " -NoNewline
$ReleaseMajorVersion = $Host.UI.ReadLine()

Write-Host "What is the release minor version number? " -NoNewline
$ReleaseMinorVersion = $Host.UI.ReadLine()

Write-Host "What is the release tag for v$ReleaseMajorVersion.$ReleaseMinorVersion (or leave blank if there is none)? " -NoNewline
$ReleaseTag = $Host.UI.ReadLine()

# Determine the full path to the release directory we are working with
$FullReleasesPath = "$ReleaseVersionsPath\v$ReleaseMajorVersion\m$ReleaseMinorVersion\$ReleaseMajorVersion.$ReleaseMinorVersion"

# Add the release tag if one exists
if ($ReleaseTag -ne "") {
    $FullReleasesPath += "-$ReleaseTag"
}

# Before proceeding, confirm the release folder path exists and if not, alert the user to create it
if (-Not (Test-Path $FullReleasesPath)) {
    Write-Host "`nThe release folder $FullReleasesPath does not exist!`nPlease run the PowerShell script 'CreateReleaseFolder.ps1' before running this script..."
    Exit
}

Set-Location $FullReleasesPath

# Create the CompStart folder for the release and update the appropriate path variable
New-Item -ItemType Directory -Name $CompStartFolder
$CSFolderPath = "$FullReleasesPath\$CompStartFolder"

# Create the release notes folder for the release and update the appropriate path variable
New-Item -ItemType Directory -Name $ReleaseNotesFolder
$ReleaseNotesFolderPath = "$FullReleasesPath\$ReleaseNotesFolder"

# Copy the CompStart content
Copy-Item -Path $CSBatchPath -Destination $CSFolderPath
Copy-Item -Path $CSPowerShellPath -Destination $CSFolderPath
Copy-Item -Path $ConfigPath -Destination $CSFolderPath -Recurse

# Change the working directory back to the project root
Set-Location $ProjectRootPath