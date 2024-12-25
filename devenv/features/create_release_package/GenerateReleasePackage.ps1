# This script is for automating the task of creating a release package, or in other words, a package artifact for a specific release.

# Import the Set-StartDirectory function
Import-Module ".\Set-StartDirectory.psm1"

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

# Initialize the static variables to be used in the script
$PackagesFolder = "packages"
$PackageVersionsFolder = "package-versions"
$ReleasesFolder = "releases"
$ReleaseVersionsFolder = "release-versions"
$CompStartFolder = "CompStart"
$ReleaseNotesFolder = "release-notes"
$ReleaseInstructionsFile = "instructions.txt"
$ReleasesPath = "$ProjectRootPath\$ReleasesFolder"
$PackagesPath = "$ProjectRootPath\$PackagesFolder"
$PackageVersionsPath = "$PackagesPath\$PackageVersionsFolder"
$ReleaseVersionsPath = "$ReleasesPath\$ReleaseVersionsFolder"


# Determine which release version to work with
Write-Host "`nWhat is the release major version number? " -NoNewline
$ReleaseMajorVersion = $Host.UI.ReadLine()

Write-Host "What is the release minor version number? " -NoNewline
$ReleaseMinorVersion = $Host.UI.ReadLine()

Write-Host "What is the release tag for v$ReleaseMajorVersion.$ReleaseMinorVersion (or leave blank if there is none)? " -NoNewline
$ReleaseTag = $Host.UI.ReadLine()

# Create the full release version for later
$ReleaseFullVersion = "$ReleaseMajorVersion.$ReleaseMinorVersion"

# Add the release tag if one exists
if ($ReleaseTag -ne "") {
    $ReleaseFullVersion += "-$ReleaseTag"
}

# Store the release and package subfolder paths
$ReleaseMajorPath = "$ReleaseVersionsPath\v$ReleaseMajorVersion"
$PackageMajorPath = "$PackageVersionsPath\v$ReleaseMajorVersion"
$ReleaseMinorPath = "$ReleaseMajorPath\m$ReleaseMinorVersion"
$PackageMinorPath = "$PackageMajorPath\m$ReleaseMinorVersion"
$ReleaseFullPath = "$ReleaseMinorPath\$ReleaseFullVersion"
$PackageFullPath = "$PackageMinorPath\$ReleaseFullVersion"

# Before proceeding, confirm the release folder path exists and if not, alert the user to create it
if (-Not (Test-Path $ReleaseFullPath)) {
    Write-Host "`nThe release folder $ReleaseFullPath does not exist!`nPlease create the release folder before running this script..."
    Exit
}

$ReleaseCSFolderPath = "$ReleaseFullPath\$CompStartFolder"
$ReleaseNotesFolderPath = "$ReleaseFullPath\$ReleaseNotesFolderPath"
$ReleaseInstructionsPath = "$ReleaseFullPath\$ReleaseInstructionsFile"

# Check if the release folder has the necessary folders and files
if (-Not (Test-Path $ReleaseCSFolderPath) -Or -Not (Test-Path $ReleaseNotesFolder) -Or -Not (Test-Path $ReleaseInstructionsPath)) {
    Write-Host "`nThe release folder $ReleaseFullPath is missing necessary folders and files!`nPlease ensure the release folder has the following folders and files:`n- $CompStartFolder`n- $ReleaseNotesFolder`n- $ReleaseInstructionsFile`n"
    Exit
}

# Also check if the packages folder exists
if (-Not (Test-Path $PackageFullPath)) {
    Write-Host "`nThe packages folder $PackageFullPath does not exist!`nPlease create the packages folder before running this script..."
    Exit
}

# Get the release package name
$ReleasePackageName = "CompStart-$ReleaseFullVersion.zip"

