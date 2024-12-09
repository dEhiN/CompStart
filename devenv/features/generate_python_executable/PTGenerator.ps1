# PowerShell script to automate the generation of the Python command line tool CompStart.py to an executable using the Python module PyInstaller. This script is meant to be used for releases and will assume the release folder has been created. As a result, only a "py-tool" folder will be created where everything will be copied and worked on.

# Get the location of the release folder root
$CurrentDirectory = Get-Location

# Initialize the relevant folder names to variables
$ReleasesFolder = "releases"
$DevFolder = "devenv"
$DependenciesFolder = "dependencies"

# Check to make sure we are in the project root
if (-Not (Select-String -InputObject $CurrentDirectory -Pattern "CompStart" -CaseSensitive)) {
    Write-Host "Unable to find project root"
    Exit
}

# Create the paths to be used in the script
$ReleasesPath = "$CurrentDirectory\$ReleasesFolder\"
$DevPath = "$CurrentDirectory\$DevFolder\"
$DependenciesPath = "$DevPath\$DependenciesFolder\"

