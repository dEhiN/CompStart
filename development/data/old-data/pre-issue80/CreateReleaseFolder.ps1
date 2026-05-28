# PowerShell script to create the directory structure for a new release

# Set the sleep time as a global variable
$Global:SleepTime = 2

function Add-MajorVersion {
    <#
        .SYNOPSIS
        Creates a directory for a major release version.

        .DESCRIPTION
        The `Add-MajorVersion` function creates a directory for a major release version at the specified location.

        .PARAMETER MajorVersion
        The major version of the release.

        .PARAMETER MajorPath
        The path where the major version directory will be created.

        .EXAMPLE
        Add-MajorVersion -MajorVersion "1.0" -MajorPath "C:\Releases\1.0"
        Creates a directory for the major release version 1.0 at the location C:\Releases\1.0.

        .NOTES
            Author: David H. Watson (with help from VS Code Copilot)
            GitHub: @dEhiN
            Date: 2024-12-30
    #>
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

function Add-MinorVersion {
    <#
        .SYNOPSIS
        Creates a directory for a minor release version.

        .DESCRIPTION
        The `Add-MinorVersion` function creates a directory for a minor release version at the specified location.

        .PARAMETER MinorVersion
        The minor version of the release.

        .PARAMETER MinorPath
        The path where the minor version directory will be created.

        .EXAMPLE
        Add-MinorVersion -MinorVersion "1.1" -MinorPath "C:\Releases\1.1"
        Creates a directory for the minor release version 1.1 at the location C:\Releases\1.1.

        .NOTES
            Author: David H. Watson (with help from VS Code Copilot)
            GitHub: @dEhiN
            Date: 2024-12-30
    #>
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

function Add-ReleaseVersion {
    <#
        .SYNOPSIS
        Creates a directory for a release version.

        .DESCRIPTION
        The `Add-ReleaseVersion` function creates a directory for a release version at the specified location.

        .PARAMETER ReleaseVersion
        The version of the release.

        .PARAMETER ReleasePath
        The path where the release version directory will be created.

        .EXAMPLE
        Add-ReleaseVersion -ReleaseVersion "2.0" -ReleasePath "C:\Releases\2.0"
        Creates a directory for the release version 2.0 at the location C:\Releases\2.0.

        .NOTES
            Author: David H. Watson (with help from VS Code Copilot)
            GitHub: @dEhiN
            Date: 2024-12-30
    #>
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
Import-Module "$PSScriptRoot\Set-StartDirectory.psm1"

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
$ReleaseVersionsFolder = "versions"
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

# Change the working directory back to the project root
Write-Host "`nChanging directory back to project root..."
Start-Sleep $Global:SleepTime
Set-Location $ProjectRootPath