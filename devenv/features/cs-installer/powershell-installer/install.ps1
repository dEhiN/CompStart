# This will be the installation script used for CompStart

# GLobal variables
$Global:SleepTime = 2
$Global:SplitChar = [System.IO.Path]::DirectorySeparatorChar
$Global:CSParentPath = [System.Environment]::GetFolderPath('LocalApplicationData')


function New-CSFolder {
    <#
    .SYNOPSIS
        Creates a CompStart folder in the specified path or in the default local application data folder.

    .DESCRIPTION
        The New-CSFolder function creates a folder named "CompStart" in the path specified by the user. If no path is specified or if the provided path is not valid, the folder will be created in the default local application data folder. If the folder already exists, the function will do nothing.

    .PARAMETER SuppliedPath
        Optional path where the CompStart folder should be created. If the path is not valid or the parameter is not specified, the folder will be created in the default local application data folder.

    .RETURNS
        [bool] Returns $true if the folder was created, otherwise $false.

    .EXAMPLE
        PS> New-CSFolder -SuppliedPath "C:\MyPath"
        Creates the CompStart folder in "C:\MyPath" if the path is valid.

    .EXAMPLE
        PS> New-CSFolder
        Creates the CompStart folder in the default local application data folder.

    .NOTES
        Author: David H. Watson
        Date: 2024-12-28
    #>
    [CmdletBinding()]
    param (
        [string] $SuppliedPath
    )

    # Initialize function variables
    $CSFolder = "CompStart"
    $RetValue = $false

    # Test the passed in parameter and use it if it's a valid path
    if ($SuppliedPath) {
        if (-Not (Test-Path -Path $SuppliedPath)) {
            Write-Host "$SuppliedPath is not a valid file system path...defaulting to $Global:CSParentPath..."
        }
        else {
            $Global:CSParentPath = $SuppliedPath
        }
    }

    # Set the full CompStart folder path
    $CSFullPath = $Global:CSParentPath + $Global:SplitChar + $CSFolder

    # Create the folder if need be
    if (-Not (Test-Path $CSFullPath)) {
        Write-Host "`nCreating CompStart folder..."
        Start-Sleep $Global:SleepTime
        New-Item -Path $CSFullPath -ItemType "Directory" > $null
        Write-Host "...folder successfully created at $CSFullPath"
        $RetValue = $true
    }
    else {
        Write-Host "`nExisting CompStart folder found at $CSFullPath..."
        Start-Sleep $Global:SleepTime
        Write-Host "...skipping this step"
    }

    return $RetValue
}

# Check if the current environment is production or not
$IsProdEnv = $false

if ($IsProdEnv) {
    Write-Host "Production isn't ready yet. Try again later..."
    Exit
}

# Get a list of all the files to "install"
$InstallRelPath = "installer-files"
$InstallFullPath = ($PSScriptRoot + $global:SplitChar + $InstallRelPath)
$FilesList = Get-ChildItem -Recurse $InstallFullPath
foreach ($Item in $FilesList) {
    Write-Host $Item.FullName
}

# Create the CompStart folder if required
New-CSFolder