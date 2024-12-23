# PowerShell script to create the directory structure for a new release

# Set the sleep time as a global variable
$Global:SleepTime = 1

# Function to create a folder for the major version of a release
function Add-MajorVersion {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0)]
        [string]$MajorVersion,

        [Parameter(Mandatory, Position = 1)]
        [string]$MajorPath
    )
    Write-Host "Creating directory for release major version $MajorVersion..."
    Write-Host "...at $MajorPath"
    Start-Sleep -Seconds $Global:SleepTime
    New-Item $MajorPath -ItemType Directory > $null
}

# Function to create a folder for the minor version of a release
function Add-MinorVersion {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0)]
        [string]$MinorVersion,

        [Parameter(Mandatory, Position = 1)]
        [string]$MinorPath
    )
    Write-Host "Creating directory for release minor version $MinorVersion..."
    Write-Host "...at $MinorPath"
    Start-Sleep -Seconds $Global:SleepTime
    New-Item $MinorPath -ItemType Directory > $null
}

# Function to create a folder for a release
function Add-ReleaseVersion {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0)]
        [string]$ReleaseVersion,

        [Parameter(Mandatory, Position = 1)]
        [string]$ReleasePath
    )
    Write-Host "Creating directory for release $ReleaseVersion..."
    Write-Host "...at $ReleasePath"
    Start-Sleep -Seconds $Global:SleepTime
    New-Item $ReleasePath -ItemType Directory > $null
}

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

# Initialize the variables to be used in the script
$ReleasesFolder = "releases"
$ReleaseVersionsFolder = "release-versions"
$ReleaseVersionsPath = "$ProjectRootPath\$ReleasesFolder\$ReleaseVersionsFolder"

# Determine which release version to create
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

# Store the release subfolder paths
$ReleaseMajorPath = "$ReleaseVersionsPath\v$ReleaseMajorVersion"
$ReleaseMinorPath = "$ReleaseMajorPath\m$ReleaseMinorVersion"
$ReleaseFullPath = "$ReleaseMinorPath\$ReleaseFullVersion"

# Before proceeding, check if the paths exist
if (-Not (Test-Path $ReleaseMajorPath)) {
    Write-Host "`nCannot find a directory for the release major version $ReleaseMajorVersion..."
    Add-MajorVersion $ReleaseMajorVersion $ReleaseMajorPath
}
else {
    Write-Host "`nThere already exists a release major version $ReleaseMajorVersion folder...skipping this step..."
    Start-Sleep $Global:SleepTime
}

if (-Not (Test-Path $ReleaseMinorPath)) {
    Write-Host "`nCannot find a directory for the release minor version $ReleaseMinorVersion..."
    Add-MinorVersion $ReleaseMinorVersion $ReleaseMinorPath
}
else {
    Write-Host "`nThere already exists a release minor version $ReleaseMinorVersion folder...skipping this step..."
    Start-Sleep $Global:SleepTime
}

if (-Not (Test-Path $ReleaseFullPath)) {
    Write-Host "`nCannot find a directory for the release $ReleaseFullVersion..."
    Add-ReleaseVersion $ReleaseFullVersion $ReleaseFullPath
}
else {
    Write-Host "`nThere already exists a release $ReleaseFullVersion folder...skipping this step..."
    Start-Sleep $Global:SleepTime
}