# PowerShell script to automate the production release process.
<#
    .SYNOPSIS
    This script will be used to create a new release and package it for deployment.

    .DESCRIPTION
    The script will perform the following steps:
    
    1. Create new release and package folders, including major and minor version directories
    2. Create any release artifacts that need to be generated
    3. Copy all release artifacts to the appropriate locations
    4. Generate a package artifact for the release
    5. Copy the package artifact to the appropriate location
    
    The script will also update the release notes and notify the team of the new release. The script will be run by the release manager as part of the production release process.
#>

# Script-global variables
$Script:SleepTime = 2
$Script:OSSeparatorChar = [System.IO.Path]::DirectorySeparatorChar
$Script:CSParentPath = [System.Environment]::GetFolderPath('LocalApplicationData')
$Script:CSFolder = "CompStart"
$Script:InstallerFolder = "installer-files"
$Script:DefRetValue = $false

function Set-ProjectRoot {
    # This function was created using GitHub Copilot. It was taken from the function "set_start_dir" function in the Python module "cs_helper.py". It has been modified to work in PowerShell and to be more idiomatic to the language.
    
    <#
        .SYNOPSIS
        Small helper function to set the starting directory to the project root.

        .DESCRIPTION
        This function will get the path for the current working directory (cwd) and check to see if the CompStart project root directory is already on it. It will check for five scenarios:

        1. There is no folder at all
        2. There is one folder at the end of the current working directory path
        3. There is one folder but not at the end of the current working directory path
        4. There is more than one folder but the last one is at the end of the current working directory path
        5. There is more than one folder and the last one is not at the end of the current working directory path

        .OUTPUTS
        [bool] Value specifying if the folder to check for was found on the current working directory path. Essentially scenarios 2-5 above will return True while scenario 1 will return False. It will be assumed that if this function returns true, then the function Set-Location has been used to move the current working directory to the desired location.

        .EXAMPLE
        Set-StartDirectory
        Checks if the directory "CompStart" is in the current working directory path and sets the location to it if found.

        .NOTES
            Author: David H. Watson (with help from VS Code Copilot)
            GitHub: @dEhiN
            Date: 2025-01-04
    #>

    # Initialize function variables
    $ReturnValue = $Script:DefRetValue
    $StartDirectory = $Script:CSFolder
    $SplitChar = "\" + $Script:OSSeparatorChar
    $PathDirectoriesList = (Get-Location).Path -split $SplitChar
    $AdjustedLengthPDL = $PathDirectoriesList.Length - 1

    # Get the total number of folders matching the passed in directory name on the current working directory path
    $TotalStartDirectories = ($PathDirectoriesList | Where-Object { $_ -eq $StartDirectory }).Count

    # Check for each case
    # Scenario 1 will be the default since the return variable is already $false
    # Scenarios 2-5 will be handled here
    if ($TotalStartDirectories -eq 1) {
        # Scenarios 2 or 3
        $ReturnValue = $true

        # Get the index of the CompStart folder in the list
        $IndexStartDirectory = $PathDirectoriesList.IndexOf($StartDirectory)
    }
    elseif ($TotalStartDirectories -gt 1) {
        # Scenario 4 or 5
        $ReturnValue = $true

        # Loop through to get to the last occurrence of the CompStart folder in the list
        $CountStartDirectories = 0
        $IndexStartDirectory = -1

        for ($i = 0; $i -lt $PathDirectoriesList.Length; $i++) {
            if ($PathDirectoriesList[$i] -eq $StartDirectory) {
                $CountStartDirectories++
            }

            if ($CountStartDirectories -eq $TotalStartDirectories) {
                $IndexStartDirectory = $i
                break
            }
        }
    }

    # Check if the index is at the end of the list or in the middle
    if ($IndexStartDirectory -lt $AdjustedLengthPDL) {
        # Scenario 3 or 5

        # Get the difference in folder levels between the last folder and the starting directory
        $CountDirectoriesOffset = $AdjustedLengthPDL - $IndexStartDirectory

        # Loop through and move the current working directory one folder level up
        while ($CountDirectoriesOffset -gt 0) {
            Set-Location ..
            $CountDirectoriesOffset--
        }
    }

    return $ReturnValue
}

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
        [Parameter(Mandatory)]
        [string]
        $MajorVersion,
        [Parameter(Mandatory)]
        [string]
        $MajorPath
    )

    Write-Host "Creating directory for release major version $MajorVersion..."
    Write-Host "...at $MajorPath"
    Start-Sleep -Seconds $Script:SleepTime
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
        [Parameter(Mandatory)]
        [string]
        $MinorVersion,
        [Parameter(Mandatory)]
        [string]
        $MinorPath
    )

    Write-Host "Creating directory for release minor version $MinorVersion..."
    Write-Host "...at $MinorPath"
    Start-Sleep -Seconds $Script:SleepTime
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
        [Parameter(Mandatory)]
        [string]
        $ReleaseVersion,
        [Parameter(Mandatory)]
        [string]
        $ReleasePath
    )

    Write-Host "Creating directory for release $ReleaseVersion..."
    Write-Host "...at $ReleasePath"
    Start-Sleep -Seconds $Script:SleepTime
    New-Item $ReleasePath -ItemType Directory > $null
}

function Start-Release {
    <#
        .SYNOPSIS
        Starts the release process.

        .DESCRIPTION
        The `Start-Release` function initiates the release process by creating the necessary directories for the release.

        .PARAMETER MajorVersion
        The major version of the release.

        .PARAMETER MinorVersion
        The minor version of the release.

        .PARAMETER ReleaseVersion
        The version of the release.

        .EXAMPLE
        Start-Release -MajorVersion "1" -MinorVersion "0" -ReleaseVersion "1.0"
        Initiates the release process for version 1.0.

        .NOTES
            Author: David H. Watson (with help from VS Code Copilot)
            GitHub: @dEhiN
            Date: 2025-01-04
    #>
    
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]
        $MajorVersion,
        [Parameter(Mandatory)]
        [string]
        $MinorVersion,
        [Parameter(Mandatory)]
        [string]
        $ReleaseVersion
    )
}