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