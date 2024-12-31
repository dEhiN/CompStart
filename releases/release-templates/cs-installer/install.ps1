# This will be the installation script used for CompStart

# Script-global variables
$Script:SleepTime = 2
$Script:OSSeparatorChar = [System.IO.Path]::DirectorySeparatorChar
$Script:CSParentPath = [System.Environment]::GetFolderPath('LocalApplicationData')
$Script:CSFolder = "CompStart"
$Script:InstallerFolder = "installer-files"
$Script:FuncRetValue = $false

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
            Author: David H. Watson (with help from VS Code Copilot)
            GitHub: @dEhiN
            Date: 2024-12-28
    #>
    [CmdletBinding()]
    param (
        [string] $SuppliedPath
    )

    # Test the passed in parameter and use it if it's a valid path
    if ($SuppliedPath) {
        if (-Not (Test-Path -Path $SuppliedPath)) {
            Write-Host "$SuppliedPath is not a valid file system path...defaulting to $Script:CSParentPath..."
        }
        else {
            $Script:CSParentPath = $SuppliedPath
        }
    }

    # Set the full CompStart folder path
    $CSFullPath = $Script:CSParentPath + $Script:OSSeparatorChar + $Script:CSFolder

    # Create the folder if need be
    if (-Not (Test-Path $CSFullPath)) {
        Write-Host "`nCreating CompStart folder..." -NoNewline
        Start-Sleep $Script:SleepTime
        New-Item -Path $CSFullPath -ItemType "Directory" > $null
        Write-Host "...folder successfully created at $CSFullPath"
        $Script:FuncRetValue = $true
    }
    else {
        Write-Host "`nExisting CompStart folder found at $CSFullPath..." -NoNewline
        Start-Sleep $Script:SleepTime
        Write-Host "...skipping this step"
    }

    return $Script:FuncRetValue
}

function Install-CSFiles {
    <#
        .SYNOPSIS
            Installs the files required for CompStart.

        .DESCRIPTION
            The Install-CSFiles function installs the files required for CompStart. The files are copied from the installer-files folder to the CompStart folder. If the files already exist in the CompStart folder, they will be overwritten.

        .RETURNS
            [bool] Returns $true if the files were successfully installed, otherwise $false.

        .EXAMPLE
            PS> Install-CSFiles
            Installs the files required for CompStart.

        .NOTES
            Author: David H. Watson (with help from VS Code Copilot)
            GitHub: @dEhiN
            Date: 2024-12-28
    #>

    Write-Host "`nStarting installation of CompStart files..."
    Start-Sleep $Script:SleepTime

    # Set the destination path for the installed files
    $DestPath = $Script:CSParentPath + $Script:OSSeparatorChar + "CompStart" + $Script:OSSeparatorChar

    # Get a list of all the files to "install"
    $FilesList = Get-ChildItem -Recurse $InstallFullPath

    # Copy the files to the CompStart folder
    foreach ($Item in $FilesList) {
        $ItemFullPath = $DestPath + $Item.Name
        Write-Host "...Installing $($Item.Name)..."
        Start-Sleep $Script:SleepTime
        Copy-Item -Path $Item.FullName -Destination $ItemFullPath -Force
    }

    Write-Host "`...successfully installed all files to $DestPath"
}

# Main script logic

# Check if the current environment is production or not
$IsProdEnv = $false

if ($IsProdEnv) {
    Write-Host "Production isn't ready yet. Try again later..."
    Exit
}

# Create the CompStart folder if required
New-CSFolder > $null

# Install the required files
Install-CSFiles  > $null