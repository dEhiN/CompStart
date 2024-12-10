# PowerShell script to automate the generation of the Python command line tool CompStart.py to an executable using the Python module PyInstaller. This script is meant to be used for releases and will assume the release folder has been created. As a result, only a "py-tool" folder will be created where everything will be copied and worked on.

# Get the location of the release folder root
$CurrentDirectory = Get-Location

# Check to make sure we are in the project root
if (-Not (Select-String -InputObject $CurrentDirectory -Pattern "CompStart" -CaseSensitive)) {
    # Inform user project root can't be found and the script is ending
    Write-Host "Unable to find project root. Quitting script..."
    Exit
}

# Initialize the relevant folder names
$ReleasesFolder = "releases"
$DevFolder = "devenv"
$DependenciesFolder = "dependencies"

# Create the paths to be used in the script
$ReleasesPath = "$CurrentDirectory\$ReleasesFolder"
$DevPath = "$CurrentDirectory\$DevFolder"
$DependenciesPath = "$DevPath\$DependenciesFolder"

# Determine which version number we are working with
Write-Host "What is the release major version number? " -NoNewline
$ReleaseMajorVersion = $Host.UI.ReadLine()

Write-Host "What is the release minor version number? " -NoNewline
$ReleaseMinorVersion = $Host.UI.ReadLine()

Write-Host "Please enter a subfolder under v$ReleaseMajorVersion\m$ReleaseMinorVersion or leave blank if there is none: " -NoNewline
$Subfolder = $Host.UI.ReadLine()

$FullReleasesPath = "$ReleasesPath\v$ReleaseMajorVersion\m$ReleaseMinorVersion"

if ($Subfolder -ne "") {
    $FullReleasesPath += "\$Subfolder"
}

