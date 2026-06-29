# This will be the installation script used for CompStart

# Script-global variables
$Script:SleepTime = 2
$Script:OSSeparatorChar = [System.IO.Path]::DirectorySeparatorChar
$Script:CSParentPath = [System.Environment]::GetFolderPath('LocalApplicationData')
$Script:WinStartupFolderPath = [System.Environment]::GetFolderPath('Startup')
$Script:CSFolder = "CompStart"
$Script:CSFullPath = ""
$Script:CSShortcutName = "CompStart.lnk"
$Script:CSShortcutTarget = "CompStart.bat"
$Script:InstallerFolder = "installer-files"

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

    # Set up the return flag variable
    $FuncRetValue = $false

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
    $Script:CSFullPath = $Script:CSParentPath + $Script:OSSeparatorChar + $Script:CSFolder

    # Create the folder if need be
    if (-Not (Test-Path $Script:CSFullPath)) {
        Write-Host "`nCreating CompStart folder..." -NoNewline
        Start-Sleep $Script:SleepTime
        New-Item -Path $Script:CSFullPath -ItemType "Directory" > $null
        Write-Host "...folder successfully created at $Script:CSFullPath"
        $FuncRetValue = $true
    }
    else {
        Write-Host "`nExisting CompStart folder found at $CSFullPath..." -NoNewline
        Start-Sleep $Script:SleepTime
        Write-Host "...skipping this step"
        $FuncRetValue = $true
    }

    return $FuncRetValue
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

    # Set up the return flag variable
    $FuncRetValue = $false


    Write-Host "`nStarting installation of CompStart..."
    Start-Sleep $Script:SleepTime

    # Get a list of all the files to install
    Write-Host "`nGenerating list of files and folders to install..."
    Start-Sleep $Script:SleepTime
    $InstallerFullPath = $PSScriptRoot + $Script:OSSeparatorChar + $Script:InstallerFolder
    $InstallerFilesList = Get-ChildItem -Recurse $InstallerFullPath

    # Before proceeding, confirm that there are files to install - in other words, that $InstallerFilesList isn't blank. If there aren't any files to install, remove the created "CompStart" folder if necessary, and exit the script.
    if (-Not $InstallerFilesList) {
        Write-Host "There is nothing to install..."
        Start-Sleep $Script:SleepTime
        Write-Host "Cleaning up any changes made by this script..."
        Start-Sleep $Script:SleepTime
        if (Test-Path $Script:CSFullPath) {
            Remove-Item -Recurse -Path $Script:CSFullPath
            Write-Host "Cleanup complete..."
        }
        else {
            Write-Host "No changes were made..."
        }
        Start-Sleep $Script:SleepTime
        Write-Host "Exiting the script..."
        Start-Sleep $Script:SleepTime
    }
    else {
        # Set the initial destination path
        $DestPath = $Script:CSFullPath

        # Copy everything over in one go
        Write-Host "`nSetting up files and folders..."
        Start-Sleep $Script:SleepTime
        Copy-Item -Recurse -Path "$InstallerFullPath\*" -Destination $DestPath -Force
        $FuncRetValue = $true
    }

    return $FuncRetValue
}

function New-CSShortcut {
    <#
        .SYNOPSIS
            Creates a new shortcut or symlink for CompStart.ps1 in the OS's startup programs area.

        .DESCRIPTION
            The New-CSShortcut function creates a shortcut for CompStart.p1 and places it in the operating system's area for programs that start when the user logs in. The function takes an optional parameter that specifies which operating system is being worked with. If the parameter isn't provided, the function defaults to Windows. Helper functions are used to create the OS specific startup shortcuts.

        .PARAMETER OperatingSystem
            Optional string parameter specifying the operating system to work with. If the parameter is not present, the default operating system of Windows is used. Note: Currently, only Windows works as the OS.

        .RETURNS
            [bool] Returns $true if the shortcut was created, otherwise $false.

        .EXAMPLE
            PS> New-CSShortcut
            Assumes the operating system is Windows and creates a link to CompStart.ps1 in C:\Users\<username>\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup

        .EXAMPLE
            PS> New-CSShortcut -OperatingSystem "Windows"
            Creates a link to CompStart.ps1 in C:\Users\<username>\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup

        .NOTES
            Author: David H. Watson
            GitHub: @dEhiN
            Date: 2026-06-20
    #>
    [CmdletBinding()]
    param (
        [string] $OperatingSystem
    )

    # Set up the return flag variable
    $FuncRetValue = $false

    # Specify which type of OS to work with:
    # Windows = 1
    $OSType = 1

    if ($OSType -eq 1) {
        Write-Host "`nCreating the Windows startup shortcut link..."
        Start-Sleep $Script:SleepTime
        $FuncRetValue = New-WindowsStartShortcut
    }

    return $FuncRetValue
}

function New-WindowsStartShortcut {
    <#
        .SYNOPSIS
            Creates a new Windows shortcut for CompStart.ps1 in the user's startup folder.

        .DESCRIPTION
            The New-WindowsStartShortcut function creates a Windows shortcut for CompStart.ps1 and stores it in the user's startup folder. Specifically, it is stored in the location that the Windows Run command "shell:startup" returns, which is usually the Startup folder for the user Start Menu.

        .RETURNS
            [bool] Returns $true if the shortcut was created, otherwise $false.

        .EXAMPLE
            PS> New-WindowsStartShortcut
            Creates a link to CompStart.ps1 in C:\Users\<username>\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup

        .NOTES
            Author: David H. Watson
            GitHub: @dEhiN
            Date: 2026-06-24
    #>

    # Confirm the Windows Startup folder location exists
    if (-Not $Script:WinStartupFolderPath) {
        # A startup folder doesn't exist, so not creating the shortcut
        Write-Host "`nCannot determine the location of the Start folder..."
        return $false
    }

    # Create the COM Object to use for generating the shortcut
    $WshShell = New-Object -ComObject WScript.Shell

    # Use the built-in method to create a shortcut
    $CSWindowsShortcut = $WshShell.CreateShortcut($Script:WinStartupFolderPath + $Script:OSSeparatorChar + $Script:CSShortcutName)

    # Set the target path to CompStart.bat
    $CSWindowsShortcut.TargetPath = $Script:CSFullPath + $Script:OSSeparatorChar + $Script:CSShortcutTarget

    # Save or create the shortcut
    $CSWindowsShortcut.Save()

    return $true
}


# Main script logic

# Check if the current environment is production or not
$IsProdEnv = $false

if ($IsProdEnv) {
    Write-Host "Production isn't ready yet. Try again later..."
    Exit
}

# Create the CompStart folder if required
$CSFolderSuccess = New-CSFolder

# Install the required files
$CSFilesSuccess = Install-CSFiles

# Create the CompStart.ps1 shortcut link
$CSShortcutSuccess = New-CSShortcut

# Let the user know the results of the installation
if ($CSFolderSuccess -and $CSFilesSuccess -and $CSShortcutSuccess) {
    Write-Host "`n...CompStart has been fully installed!"
}
else {
    Write-Host "`n...The installation failed!`nPlease contact the developer team at https://github.com/dEhiN/CompStart/ and let them know of any errors that occurred."
}

# Wait for the user to quit the script
Start-Sleep $Script:SleepTime
Write-Host "Please press any key to exit this script..." -NoNewline
$Host.UI.ReadLine()