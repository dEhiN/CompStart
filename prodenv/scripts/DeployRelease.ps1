# PowerShell script to automate the production release process.
<#
    .SYNOPSIS
    This script will be used to create a new release and package it for deployment.

    .DESCRIPTION
    The `DeployRelease` script will perform the following steps:
    
    1. Create new release and package folders, including major and minor version directories
    2. Create any release artifacts that need to be generated
    3. Copy all release artifacts to the appropriate locations
    4. Generate a package artifact for the release
    5. Copy the package artifact to the appropriate location
    
    The script will also update the release notes and notify the team of the new release. The script will be run by the release manager as part of the production release process.
#>

# Section: Script Variables
$Script:SleepTimer = 2
$Script:DefaultReturnVal = $false
$Script:OSSeparatorChar = [System.IO.Path]::DirectorySeparatorChar
$Script:PyInstallerCmd = "pyinstaller"
$Script:ReleaseDetails = [ordered]@{
    MajorVersion = ""
    MinorVersion = ""
    Tag          = ""
    FullVersion  = ""
}
$Script:FileNames = [ordered]@{
    CSBatchScript             = "CompStart.bat"
    CSPowerShellScript        = "CompStart.ps1"
    CSPythonScript            = "CompStart.py"
    CSPythonExe               = "CompStart.exe"

    ReleaseInstructionsText   = "instructions.txt"
    ReleaseNotesMarkdown      = "release_notes.md"

    InstallerPowerShellScript = "install.ps1"
}
$Script:FolderNames = [ordered]@{
    DevEnv                = "devenv"
    Config                = "config"
    PythonDependencies    = "dependencies"

    ProdEnv               = "prodenv"
    Assets                = "assets"
    ReleaseAssets         = "release-assets"
    InstallerAssets       = "cs-installer"
    Packages              = "packages"
    Releases              = "releases"
    ReleaseMajorPrefix    = "v"
    ReleaseMinorPrefix    = "m"

    CompStart             = "CompStart"
    PyTool                = "py-tool"
    ReleaseNotes          = "release-notes"
    PyIDist               = "dist"

    ParentInstallLocation = "LocalApplicationData"
    InstallerFiles        = "installer-files"
}
$Script:PathVars = [ordered]@{    
    ParentInstallFolder             = [System.Environment]::GetFolderPath($Script:FolderNames.ParentInstallLocation)
    ProjectRootFolder               = ""

    DevFolder                       = ""
    ProdFolder                      = ""

    DevConfigFolder                 = ""
    DevPythonDependenciesFolder     = ""
    DevCSPythonScript               = ""
    DevCSBatchScript                = ""
    DevCSPowerShellScript           = ""

    AssetsFolder                    = ""
    AssetsReleaseFolder             = ""
    AssetsInstallerFolder           = ""

    AssetInstallerPowerShellScript  = ""
    AssetReleaseNotesMarkdown       = ""
    AssetInstructionsText           = ""

    PackagesFolder                  = ""
    PackageMajorFolder              = ""
    PackageMinorFolder              = ""

    ReleasesFolder                  = ""
    ReleaseMajorFolder              = ""
    ReleaseMinorFolder              = ""
    ReleaseFullFolder               = ""

    ReleaseNotesFolder              = ""
    ReleasesOuterCSFolder           = ""
    ReleaseInnerCSFolder            = ""
    ReleasePyToolFolder             = ""
    ReleasePythonDependenciesFolder = ""
    ReleaseInstallerFolder          = ""
}

# Section: Script Functions
function Start-Release {
    <#
    .SYNOPSIS
        Starts the release process.

    .DESCRIPTION
        The `Start-Release` function initiates the release process by going through the 4 major tasks involved:

        1. Set (up) the release folder structure for both the releases and packages directories
        2. Invoke the Python module `pyinstaller` to generate an executable from the CompStart Python script
        3. Copy the release-specific content from the devenv and the prodenv>assets folders to the release folder
        4. New release package - creates a new release package

        The function first gives the user a menu with a choice. The user can start the full release process as described in the 4 tasks, or perform each task separately. This will allow the user to skip tasks that may not be needed.

    .PARAMETER None
        This function does not take any parameters.

    .EXAMPLE
        Start-Release
        Initiates the release process for whatever release details are stored in the $Script:ReleaseFullVersion variable.

    .NOTES
        Author: David H. Watson (with help from VS Code Copilot)
        GitHub: @dEhiN
        Created: 2025-01-04
        Updated: 2025-01-16
    #>

    # Function variables
    $UserMenu = "`nPlease choose one of the following:`n[1] Start the full release process`n[2] Set up the release folder structure`n[3] Generate the Python executable`n[4] Copy the contents needed for a release over to the release folder`n[5] Create a release package`n[Q] Quit`n`nWhat would you like to do? "
    $UserOptions = @("1", "2", "3", "4", "5", "Q")
    $ChoiceFullRelease = 1
    $ChoiceSetReleaseFolder = 2
    $ChoiceInvokePythonTool = 3
    $ChoiceCopyReleaseContents = 4
    $ChoiceNewReleasePackage = 5
    $ChoiceQuit = "Q"

    # Loop until user answers prompt
    $LoopTrue = $True
    do {
        # Show the user the menu options
        Write-Host $UserMenu -NoNewline
        $UserPrompt = $Host.UI.ReadLine()

        # Check the user entered a valid choice
        if ($UserPrompt -in $UserOptions) {
            # Check if the user wants to quit
            if ($UserPrompt -eq $ChoiceQuit) {
                Write-Host "`nExiting the script...`n"
                Exit
            }

            $UserChoice = [int]$UserPrompt

            # Tell loop to quit
            $LoopTrue = $False
        }
        else {
            Write-Host "Please make a valid choice!"
        }
    } while ($LoopTrue -eq $True)

    # Task 1
    if (($UserChoice -eq $ChoiceFullRelease) -or ($UserChoice -eq $ChoiceSetReleaseFolder)) {
        Set-ReleaseFolderStructure
    }

    # Task 2
    if (($UserChoice -eq $ChoiceFullRelease) -or ($UserChoice -eq $ChoiceInvokePythonTool)) {
        Invoke-PythonTool
    }

    # Task 3
    if (($UserChoice -eq $ChoiceFullRelease) -or ($UserChoice -eq $ChoiceCopyReleaseContents)) {
        Copy-ReleaseContents
    }

    # Task 4
    if (($UserChoice -eq $ChoiceFullRelease) -or ($UserChoice -eq $ChoiceNewReleasePackage)) {
        New-ReleasePackage
    }
}
function Invoke-PythonTool {
    <#
    .SYNOPSIS
        Generates an executable from the CompStart.py script using the PyInstaller Python module.

    .DESCRIPTION
        The function `Invoke-PythonTool` generates an executable file from the CompStart.py script by using the PyInstaller Python module. This is done by calling the `pyinstaller` command with the `--onefile` parameter to create a standalone executable file. As part of the process, the function checks that the necessary paths and files needed by PyInstaller exist.
        
        The function first checks to ensure a release folder exists. If there is no release folder, the user is alerted and the script is exited. Next, the function calls `Set-PyToolFolder` to make sure the py-tool folder is correctly set up. It then copies over the CompStart.py script and all the Python script dependencies from the devenv folder to the py-tool folder. Finally, it generates the executable CompStart.exe.

    .PARAMETER None
        This function does not take any parameters.

    .EXAMPLE
        Invoke-PythonTool
        Generates a CompStart.exe executable file from the CompStart.py script using PyInstaller.

    .NOTES
        Author: David H. Watson (with help from VS Code Copilot)
        GitHub: @dEhiN
        Created: 2024-01-13
        Updated: 2025-01-14
    #>

    # Before proceeding, set the location to the release folder
    Set-ReleaseFolderLocation

    # Set up the py-tool folder for the release
    Add-PyToolFolder

    # Copy the necessary files to the py-tool folder
    Add-PyToolContents

    # Confirm we are in the correct location
    Set-Location $Script:PathVars.ReleasePyToolFolder

    # Let user know the Python executable will be created after a 5 second countdown
    Write-Host "`nCreating Python executable in..."
    for ($counter = 5; $counter -gt 0; $counter--) {
        Write-Host "$counter..."
        Start-Sleep -Seconds 1
    }

    # Create the Python executable
    $PyIArgumentArray = @(
        $Script:FileNames.CSPythonScript,
        "--onefile"
    )

    Start-Process -FilePath $Script:PyInstallerCmd -ArgumentList $PyIArgumentArray -NoNewWindow -Wait
    Write-Host "`nPython executable successfully created"
}
function Update-PathVars {
    <#
    .SYNOPSIS
        Updates the project environment path variables to be used by this script.

    .DESCRIPTION
        The `Update-PathVars` function sets and updates various path variables used throughout the project. It organizes paths for development, production, assets, packages, and releases based on the project root path and folder names. Specifically, it updates all the properties in the `$Script:PathVars` dictionary.

    .PARAMETER None
        This function does not take any parameters.

    .EXAMPLE
        Update-PathVars
        Updates all the path variables based on the current project root path and folder names.

    .NOTES
        Author: David H. Watson (with help from VS Code Copilot)
        GitHub: @dEhiN
        Created: 2025-01-12
        Updated: 2025-01-14
    #>

    # Set the project root path for easy reference
    $ProjectRootPath = $Script:PathVars.ProjectRootFolder 

    # First level folder paths
    $Script:PathVars.DevFolder = "$ProjectRootPath$($Script:OSSeparatorChar)$($Script:FolderNames.DevEnv)"
    $Script:PathVars.ProdFolder = "$ProjectRootPath$($Script:OSSeparatorChar)$($Script:FolderNames.ProdEnv)"

    # Dev related folder paths
    $DevPath = $Script:PathVars.DevFolder 
    $Script:PathVars.DevConfigFolder = "$DevPath$($Script:OSSeparatorChar)$($Script:FolderNames.Config)"
    $Script:PathVars.DevPythonDependenciesFolder = "$DevPath$($Script:OSSeparatorChar)$($Script:FolderNames.PythonDependencies)"

    # Dev related file paths
    $Script:PathVars.DevCSPythonScript = "$DevPath$($Script:OSSeparatorChar)$($Script:FileNames.CSPythonScript)"
    $Script:PathVars.DevCSBatchScript = "$DevPath$($Script:OSSeparatorChar)$($Script:FileNames.CSBatchScript)"
    $Script:PathVars.DevCSPowerShellScript = "$DevPath$($Script:OSSeparatorChar)$($Script:FileNames.CSPowerShellScript)"

    # Prod related folder paths
    $ProdPath = $Script:PathVars.ProdFolder 
    $Script:PathVars.AssetsFolder = "$ProdPath$($Script:OSSeparatorChar)$($Script:FolderNames.Assets)"
    $Script:PathVars.PackagesFolder = "$ProdPath$($Script:OSSeparatorChar)$($Script:FolderNames.Packages)"
    $Script:PathVars.ReleasesFolder = "$ProdPath$($Script:OSSeparatorChar)$($Script:FolderNames.Releases)"

    # Asset related folder paths
    $AssetsPath = $Script:PathVars.AssetsFolder 
    $Script:PathVars.AssetsReleaseFolder = "$AssetsPath$($Script:OSSeparatorChar)$($Script:FolderNames.ReleaseAssets)"
    $Script:PathVars.AssetsInstallerFolder = "$AssetsPath$($Script:OSSeparatorChar)$($Script:FolderNames.InstallerAssets)"

    # Asset related file paths
    $Script:PathVars.AssetReleaseNotesMarkdown = "$AssetsPath$($Script:OSSeparatorChar)$($Script:FileNames.ReleaseNotesMarkdown)"
    $Script:PathVars.AssetInstructionsText = "$AssetsPath$($Script:OSSeparatorChar)$($Script:FileNames.ReleaseInstructionsText)"
    $Script:PathVars.AssetInstallerPowerShellScript = "$AssetsPath$($Script:OSSeparatorChar)$($Script:FileNames.InstallerPowerShellScript)"

    # Package related folder paths
    $PackagesPath = $Script:PathVars.PackagesFolder 
    $Script:PathVars.PackageMajorFolder = "$PackagesPath$($Script:OSSeparatorChar)$($Script:FolderNames.ReleaseMajorPrefix)$($Script:ReleaseDetails.MajorVersion)"
    $PackageMajorPath = $Script:PathVars.PackageMajorFolder 
    $Script:PathVars.PackageMinorFolder = "$PackageMajorPath$($Script:OSSeparatorChar)$($Script:FolderNames.ReleaseMinorPrefix)$($Script:ReleaseDetails.MinorVersion)"

    # Release related parent folder paths
    $ReleasesPath = $Script:PathVars.ReleasesFolder
    $Script:PathVars.ReleaseMajorFolder = "$ReleasesPath$($Script:OSSeparatorChar)$($Script:FolderNames.ReleaseMajorPrefix)$($Script:ReleaseDetails.MajorVersion)"
    $ReleaseMajorPath = $Script:PathVars.ReleaseMajorFolder 
    $Script:PathVars.ReleaseMinorFolder = "$ReleaseMajorPath$($Script:OSSeparatorChar)$($Script:FolderNames.ReleaseMinorPrefix)$($Script:ReleaseDetails.MinorVersion)"
    $ReleaseMinorPath = $Script:PathVars.ReleaseMinorFolder 
    $Script:PathVars.ReleaseFullFolder = "$ReleaseMinorPath$($Script:OSSeparatorChar)$($Script:ReleaseDetails.FullVersion)"

    # Release specific child folder paths
    $ReleaseFullPath = $Script:PathVars.ReleaseFullFolder
    $Script:PathVars.ReleasesOuterCSFolder = "$ReleaseFullPath$($Script:OSSeparatorChar)$($Script:FolderNames.CompStart)"
    $Script:PathVars.ReleaseNotesFolder = "$ReleaseFullPath$($Script:OSSeparatorChar)$($Script:FolderNames.ReleaseNotes)"
    $Script:PathVars.ReleasePyToolFolder = "$ReleaseFullPath$($Script:OSSeparatorChar)$($Script:FolderNames.PyTool)"
    $ReleaseOuterCSPath = $Script:PathVars.ReleasesOuterCSFolder
    $Script:PathVars.ReleaseInstallerFolder = "$ReleaseOuterCSPath$($Script:OSSeparatorChar)$($Script:FolderNames.InstallerFiles)"
    $ReleaseInstallerPath = $Script:PathVars.ReleaseInstallerFolder
    $Script:PathVars.ReleaseInnerCSFolder = "$ReleaseInstallerPath$($Script:OSSeparatorChar)$($Script:FolderNames.CompStart)"
    $ReleasePyToolFolderPath = $Script:PathVars.ReleasePyToolFolder 
    $Script:PathVars.ReleasePythonDependenciesFolder = "$ReleasePyToolFolderPath$($Script:OSSeparatorChar)$($Script:FolderNames.PythonDependencies)"
}
function Get-ReleaseDetails {
    <#
    .SYNOPSIS
        Gets the release details from the user.

    .DESCRIPTION
        The `Get-ReleaseDetails` function prompts the user for the release details, including the major version, minor version, and release tag. Those details are then stored in the script variable ReleaseDetails dictionary.

    .PARAMETER None
        This function does not take any parameters.

    .EXAMPLE
        Get-ReleaseDetails
        Prompts the user for the release details.

    .NOTES
        Author: David H. Watson (with help from VS Code Copilot)
        GitHub: @dEhiN
        Created: 2025-01-10
        Updated: 2025-01-12
    #>
    Write-Host "`nWhat is the release major version number? " -NoNewline
    $Script:ReleaseDetails.MajorVersion = $Host.UI.ReadLine()

    Write-Host "What is the release minor version number? " -NoNewline
    $Script:ReleaseDetails.MinorVersion = $Host.UI.ReadLine()

    $Script:ReleaseDetails.FullVersion = "$($Script:ReleaseDetails.MajorVersion).$($Script:ReleaseDetails.MinorVersion)"

    Write-Host "What is the release tag for version $($Script:ReleaseDetails.FullVersion) (or leave blank if there is none)? " -NoNewline
    $Script:ReleaseDetails.Tag = $Host.UI.ReadLine()

    if ($Script:ReleaseDetails.Tag) {
        $Script:ReleaseDetails.FullVersion += "-$($Script:ReleaseDetails.Tag)"
    }    
}
function Set-ProjectRoot {
    # This function was created using GitHub Copilot. It was taken from the function "set_start_dir" function in the Python module "cs_helper.py". It has been modified to work in PowerShell and to be more idiomatic to the language.
    
    <#
    .SYNOPSIS
        Small helper function to set the starting directory to the project root.

    .DESCRIPTION
        The `Set-ProjectRoot` function will get the path for the current working directory (cwd) and check to see if the CompStart project root directory is already on it. It will check for five scenarios:

        1. There is no folder at all
        2. There is one folder at the end of the current working directory path
        3. There is one folder but not at the end of the current working directory path
        4. There is more than one folder but the last one is at the end of the current working directory path
        5. There is more than one folder and the last one is not at the end of the current working directory path

    .PARAMETER None
        This function does not take any parameters.

    .OUTPUTS
        [bool] Value specifying if the folder to check for was found on the current working directory path. Essentially scenarios 2-5 above will return True while scenario 1 will return False. It will be assumed that if this function returns true, then the function Set-Location has been used to move the current working directory to the desired location.

    .EXAMPLE
        Set-StartDirectory
        Checks if the directory "CompStart" is in the current working directory path and sets the location to it if found.

    .NOTES
        Author: David H. Watson (with help from VS Code Copilot)
        GitHub: @dEhiN
        Created: 2025-01-04
        Updated: 2025-01-12
    #>

    # Initialize function variables
    $ReturnValue = $Script:DefaultReturnVal
    $StartDirectory = $Script:FolderNames.CompStart
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
function Set-ReleaseFolderStructure {
    <#
    .SYNOPSIS
        Create the folder structure for a release.

    .DESCRIPTION
        The `Set-ReleaseFolderStructure` function initiates the release process by creating the necessary directories for the release in both the releases and packages folders. The locations are first checked to see if the necessary directories already exist, and are skipped if they exist. The `Script:ReleaseDetails` dictionary is used to determine the needed directories.

    .PARAMETER None
        This function does not take any parameters.

    .EXAMPLE
        Set-ReleaseFolderStructure
        Initiates the release process for whatever release details are stored in the $Script:ReleaseFullVersion variable. See Description for more details.

    .NOTES
        Author: David H. Watson (with help from VS Code Copilot)
        GitHub: @dEhiN
        Created: 2025-01-04
        Updated: 2025-01-13
    #>
    
    # Deal with the major release version
    Set-MajorVersionPaths

    # Deal with the minor release version
    Set-MinorVersionPaths

    # Deal with the release folder
    Set-FullVersionPath
}
function Set-ReleaseFolderLocation {
    <#
    .SYNOPSIS
        Sets the current location to the release folder.

    .DESCRIPTION
        The `Set-ReleaseFolderLocation` function checks if the release folder exists for the current release version. If the folder does not exist, it alerts the user and exits the script. If the folder exists, it sets the location to the release folder and continues with the release process.

    .PARAMETER None
        This function does not take any parameters.

    .EXAMPLE
        Set-ReleaseFolderLocation
        Checks if the release folder exists for the current release version and sets that as the current version if it exists.

    .NOTES
        Author: David H. Watson (with help from VS Code Copilot)
        GitHub: @dEhiN
        Created: 2024-01-13
        Updated: 2025-01-14    
    #>

    # Set up local variables for easier access
    $ReleaseFullVersion = $Script:ReleaseDetails.FullVersion

    if (-Not (Test-Path $Script:PathVars.ReleaseFullFolder)) {
        Write-Host "`nCannot find a release folder for release version $ReleaseFullVersion)!`nPlease create it first...exiting the script..."
        Exit
    }
    else {
        Write-Host "`nFound the release folder for release version $ReleaseFullVersion...continuing with the release process..."
        Start-Sleep $Script:SleepTimer
        Set-Location $Script:PathVars.ReleaseFullFolder
    }
}
function Set-MajorVersionPaths {
    <#
    .SYNOPSIS
        Checks for an existing major release version folder and creates one if applicable for both releases and packages.

    .DESCRIPTION
        The `Set-MajorVersionPaths` function checks both the releases and packages folders to see if there is already a directory corresponding to the MajorVersion property found in the `$Script:ReleaseDetails` dictionary. If there isn't one, the function `Add-MajorVersionFolder` will be called to create it.

    .PARAMETER None
        This function does not take any parameters.

    .EXAMPLE
        Set-MajorVersionPaths
        Checks to see if there's a folder for the major version found in the $Script:ReleaseDetails.MajorVersion property at the following locations: /prodenv/releases and /prodenv/packages, and creates it if it doesn't exist.

    .NOTES
        Author: David H. Watson (with help from VS Code Copilot)
        GitHub: @dEhiN
        Created: 2025-01-04
        Updated: 2025-01-12
    #>

    # Set up local variables for easier access
    $ReleaseMajorVersion = $Script:ReleaseDetails.MajorVersion
    $PackageMajorPath = $Script:PathVars.PackageMajorFolder 
    $ReleaseMajorPath = $Script:PathVars.ReleaseMajorFolder 

    # Check the packages directory
    if (-Not (Test-Path $PackageMajorPath)) {
        Write-Host "`nCannot find a package directory for major version $ReleaseMajorVersion..."
        Add-MajorVersionFolder -IsPackage $true
    }
    else {
        Write-Host "`nThere already exists a package directory for major version $ReleaseMajorVersion...skipping this step..."
        Start-Sleep $Script:SleepTimer
    }
    
    # Check the releases directory
    if (-Not (Test-Path $ReleaseMajorPath)) {
        Write-Host "`nCannot find a release directory for major version $ReleaseMajorVersion..."
        Add-MajorVersionFolder -IsPackage $false
    }
    else {
        Write-Host "`nThere already exists a release directory major version $ReleaseMajorVersion...skipping this step..."
        Start-Sleep $Script:SleepTimer
    }
}
function Set-MinorVersionPaths {
    <#
    .SYNOPSIS
        Checks for an existing minor release version folder and creates one if applicable for both releases and packages.

    .DESCRIPTION
        The `Set-MinorVersionPaths` function checks both the releases and packages folders to see if there is already a directory corresponding to the MinorVersion property found in the `$Script:ReleaseDetails` dictionary. If there isn't one, the function `Add-MinorVersionFolder` will be called to create it.

    .PARAMETER None
        This function does not take any parameters.

    .EXAMPLE
        Set-MinorVersionPaths
        Checks to see if there's a folder for the minor version found in the $Script:ReleaseDetails.MinorVersion property at the following locations: /prodenv/releases and /prodenv/packages, and creates it if it doesn't exist.

    .NOTES
        Author: David H. Watson (with help from VS Code Copilot)
        GitHub: @dEhiN
        Created: 2025-01-04
        Updated: 2025-01-12
    #>

    # Set up local variables for easier access
    $ReleaseMinorVersion = $Script:ReleaseDetails.MinorVersion
    $PackageMinorPath = $Script:PathVars.PackageMinorFolder 
    $ReleaseMinorPath = $Script:PathVars.ReleaseMinorFolder 

    # Check the packages directory
    if (-Not (Test-Path $PackageMinorPath)) {
        Write-Host "`nCannot find a package directory for minor version $ReleaseMinorVersion..."
        Add-MinorVersionFolder -IsPackage $true
    }
    else {
        Write-Host "`nThere already exists a package directory for minor version $ReleaseMinorVersion...skipping this step..."
        Start-Sleep $Script:SleepTimer
    }
    
    # Check the releases directory
    if (-Not (Test-Path $ReleaseMinorPath)) {
        Write-Host "`nCannot find a release directory for minor version $ReleaseMinorVersion..."
        Add-MinorVersionFolder -IsPackage $false
    }
    else {
        Write-Host "`nThere already exists a release directory for minor version $ReleaseMinorVersion...skipping this step..."
        Start-Sleep $Script:SleepTimer
    }
}
function Set-FullVersionPath {
    <#
    .SYNOPSIS
        Checks for an existing release folder and creates one if applicable.

    .DESCRIPTION
        The `Set-FullVersionPath` function checks the releases folder to see if there is already a directory corresponding to the FullVersion property found in the `$Script:ReleaseDetails` dictionary. If there isn't one, the function `Add-ReleaseVersionFolder` will be called to create it.

    .PARAMETER None
        This function does not take any parameters.

    .EXAMPLE
        Set-FullVersionPath
        Checks to see if there's a folder for the full release version found in the $Script:ReleaseDetails.FullVersion property at /prodenv/releases, and creates it if it doesn't exist.

    .NOTES
        Author: David H. Watson (with help from VS Code Copilot)
        GitHub: @dEhiN
        Created: 2025-01-04
        Updated: 2025-01-13
    #>

    # Set up local variables for easier access
    $ReleaseFullVersion = $Script:ReleaseDetails.FullVersion
    $ReleaseFullPath = $Script:PathVars.ReleaseFullFolder

    # Check the releases directory
    if (-Not (Test-Path $ReleaseFullPath)) {
        Write-Host "`nCannot find a directory for release version $ReleaseFullVersion..."
        Add-FullVersionFolder
    }
    else {
        Write-Host "`nThere already exists a directory for release version $ReleaseFullVersion...skipping this step..."
        Start-Sleep $Script:SleepTimer
    }
}
function Add-MajorVersionFolder {
    <#
    .SYNOPSIS
        Creates a directory for a major release version.

    .DESCRIPTION
        The `Add-MajorVersionFolder` function creates a directory for a major release version, based on the value found in the MajorVersion property of the `$Script:ReleaseDetails` dictionary. The function will create the directory in either the packages or releases folder based on the value of the IsPackage parameter.

    .PARAMETER IsPackage
        A boolean specifying if the directory is to be created in the packages folder or the releases folder.

    .EXAMPLE
        Add-MajorVersionFolder -IsPackage $true
        Creates a directory for the major release version found in the $Script:ReleaseDetails.MajorVersion property in the packages folder.

    .EXAMPLE
        Add-MajorVersionFolder -IsPackage $false
        Creates a directory for the major release version found in the $Script:ReleaseDetails.MajorVersion property in the releases folder.

    .NOTES
        Author: David H. Watson (with help from VS Code Copilot)
        GitHub: @dEhiN
        Created: 2024-12-30
        Updated: 2025-01-12
    #>
    
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [System.Boolean]
        $IsPackage
    )    

    if ($IsPackage) {
        $MajorPath = $Script:PathVars.PackageMajorFolder 
        $DirType = "package"
    }
    else {
        $MajorPath = $Script:PathVars.ReleaseMajorFolder 
        $DirType = "release"
    }
    
    Write-Host "Creating a $DirType directory for major version $($Script:ReleaseDetails.MajorVersion)..."
    Write-Host "...at $MajorPath"
    Start-Sleep -Seconds $Script:SleepTimer
    New-Item $MajorPath -ItemType Directory > $null
}
function Add-MinorVersionFolder {
    <#
    .SYNOPSIS
        Creates a directory for a minor release version.

    .DESCRIPTION
        The `Add-MinorVersionFolder` function creates a directory for a minor release version, based on the value found in the MinorVersion property of the `$Script:ReleaseDetails` dictionary. The function will create the directory in either the packages or releases folder based on the value of the IsPackage parameter.

    .PARAMETER IsPackage
        A boolean specifying if the directory is to be created in the packages folder or the releases folder.

    .EXAMPLE
        Add-MinorVersionFolder -IsPackage $true
        Creates a directory for the minor release version found in the $Script:ReleaseDetails.MinorVersion property in the packages folder.

    .EXAMPLE
        Add-MajorVersionFolder -IsPackage $false
        Creates a directory for the minor release version found in the $Script:ReleaseDetails.MinorVersion property in the releases folder.

    .NOTES
        Author: David H. Watson (with help from VS Code Copilot)
        GitHub: @dEhiN
        Created: 2024-12-30
        Updated: 2025-01-12
    #>
    
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [System.Boolean]
        $IsPackage
    )    

    if ($IsPackage) {
        $MinorPath = $Script:PathVars.PackageMinorFolder 
        $DirType = "package"
    }
    else {
        $MinorPath = $Script:PathVars.ReleaseMinorFolder 
        $DirType = "release"
    }
    
    Write-Host "Creating a $DirType directory for minor version $($Script:ReleaseDetails.MinorVersion)..."
    Write-Host "...at $MinorPath"
    Start-Sleep -Seconds $Script:SleepTimer
    New-Item $MinorPath -ItemType Directory > $null
}
function Add-FullVersionFolder {
    <#
    .SYNOPSIS
        Creates a directory for a release version.

    .DESCRIPTION
        The `Add-FullVersionFolder` function creates a directory for a release version based on the value found in the FullVersion property of the `$Script:ReleaseDetails` dictionary. The function will create the directory in the releases folder.

    .PARAMETER None
        This function does not take any parameters.

    .EXAMPLE
        Add-FullVersionFolder
        Creates a directory for the release version found in the $Script:ReleaseDetails.FullVersion property in the releases folder.

    .NOTES
        Author: David H. Watson (with help from VS Code Copilot)
        GitHub: @dEhiN
        Created: 2024-12-30
        Updated: 2025-01-13
    #>

    # Set up local variables for easier access
    $ReleaseFullVersion = $Script:ReleaseDetails.FullVersion
    $ReleaseFullPath = $Script:PathVars.ReleaseFullFolder
        
    Write-Host "Creating a directory for release version $ReleaseFullVersion..."
    Write-Host "...at $ReleaseFullPath"
    Start-Sleep -Seconds $Script:SleepTimer
    New-Item $ReleaseFullPath -ItemType Directory > $null
}
function Add-CompStartFolder {
    <#
    .SYNOPSIS
        Creates the CompStart folder directory structure for the release.

    .DESCRIPTION
        The `Add-CompStartFolder` function creates the CompStart folder and its subfolders for the release.

        The CompStart directory structure will be the following (with the release version folder as the parent directory):
        > - <release-folder>
        | - CompStart (folder)
            | - install.ps1 (script)
            | - installer-files (folder)
                | - instructions.txt (text file)
                | - CompStart (folder)
                    | - CompStart.ps1 (script)
                    | - CompStart.bat (script)
                    | - config (folder)
                        | - default_startup.json (config file)
                        | - startup_data.json (config file)
                        | - schema (folder)
                            | - startup_data.schema.json (schema file)
                            | - startup_item.schema.json (schema file)
        
        This directory structure will allow the installer script to correctly set up the CompStart folder and its contents during installation.

    .PARAMETER None
        This function does not take any parameters.

    .EXAMPLE
        Add-CompStartFolder
        Adds the CompStart folder and subfolders to the release folder for the release version stored in the $Script:ReleaseDetails.FullVersion variable. See Description for more details.

    .NOTES
        Author: David H. Watson (with help from VS Code Copilot)
        GitHub: @dEhiN
        Created: 2024-01-14
        Updated: 2025-01-16
    #>

    # Set up local variables for easier access
    $ReleaseFullVersion = $Script:ReleaseDetails.FullVersion
    $ReleasesOuterCSPath = $Script:PathVars.ReleasesOuterCSFolder 
    $ReleaseInstallerPath = $Script:PathVars.ReleaseInstallerFolder
    $ReleaseInnerCSPath = $Script:PathVars.ReleaseInnerCSFolder

    # Create the outer CompStart folder
    if (-Not (Test-Path $ReleasesOuterCSPath)) {
        Write-Host "`nCreating the outer CompStart folder for release version $ReleaseFullVersion..."
        Start-Sleep $Script:SleepTimer
        New-Item -ItemType Directory -Name $ReleasesOuterCSPath > $null
    }
    else {
        Write-Host "`nThere already exists an outer CompStart folder for release version $ReleaseFullVersion...skipping this step..."
        Start-Sleep $Script:SleepTimer
    }

    # Create the installer-files folder
    if (-Not (Test-Path $ReleaseInstallerPath)) {
        Write-Host "`nCreating the installer-files folder for release version $ReleaseFullVersion..."
        Start-Sleep $Script:SleepTimer
        New-Item -ItemType Directory -Name $ReleaseInstallerPath > $null
    }
    else {
        Write-Host "`nThere already exists an installer-files folder for release version $ReleaseFullVersion...skipping this step..."
        Start-Sleep $Script:SleepTimer
    }

    # Create the inner CompStart folder
    if (-Not (Test-Path $ReleaseInnerCSPath)) {
        Write-Host "`nCreating the inner CompStart folder for release version $ReleaseFullVersion..."
        Start-Sleep $Script:SleepTimer
        New-Item -ItemType Directory -Name $ReleaseInnerCSPath > $null
    }
    else {
        Write-Host "`nThere already exists an inner CompStart folder for release version $ReleaseFullVersion...skipping this step..."
        Start-Sleep $Script:SleepTimer
    }
}
function Add-PyToolFolder {
    <#
    .SYNOPSIS
        Creates the py-tool folder for the release.

    .DESCRIPTION
        The `Add-PyToolFolder` function creates the py-tool folder for the release, if it doesn't exist. If the folder exists but is not empty, it deletes the existing contents.
    
    .PARAMETER None
        This function does not take any parameters.

    .EXAMPLE
        Add-PyToolFolder
        Adds the py-tool folder to the release folder for the release version stored in the $Script:ReleaseDetails.FullVersion variable.

    .NOTES
        Author: David H. Watson (with help from VS Code Copilot)
        GitHub: @dEhiN
        Created: 2024-01-14
    #>

    # Set up local variables for easier access
    $PyToolFolder = $Script:FolderNames.PyTool
    $PyToolFolderPath = $Script:PathVars.ReleasePyToolFolder 
    
    # Confirm if the py-tool folder path exists and if not, try to create it
    if (-Not (Test-Path $PyToolFolderPath)) {
        Write-Host "`nCannot find a folder named `"$PyToolFolder`" in the release folder for release version $($Script:ReleaseDetails.FullVersion)."
        Write-Host "Creating the $PyToolFolder folder..."
        Write-Host "...at $($Script:PathVars.ReleaseFullFolder)"
        Start-Sleep -Seconds $Script:SleepTimer
        New-Item $PyToolFolderPath -ItemType Directory > $null
    }

    # Before proceeding, make sure we are in the correct directory
    Set-Location $PyToolFolderPath

    # Check to see if there's anything already in the py-tool folder and if so, delete it
    $PyToolFolderLen = (Get-ChildItem $PyToolFolderPath -Recurse).Length
    if ($PyToolFolderLen -gt 0) {
        Write-Host "`nFound items in the $PyToolFolder folder. Deleting all items..."
        Start-Sleep -Seconds $Script:SleepTimer
        Remove-Item * -Recurse -Force
        Write-Host "The folder is now empty."
    }
}
function Add-ReleaseNotesFolder {
    <#
    .SYNOPSIS
        Creates the release-notes folder for the release.

    .DESCRIPTION
        The `Add-ReleaseNotesFolder` function creates the release-notes folder for the release, if it doesn't already exist.

    .PARAMETER None
        This function does not take any parameters.

    .EXAMPLE
        Add-ReleaseNotesFolder
        Adds the release-notes folder to the release folder for the release version stored in the $Script:ReleaseDetails.FullVersion variable.

    .NOTES
        Author: David H. Watson (with help from VS Code Copilot)
        GitHub: @dEhiN
        Created: 2024-01-14
    #>

    # Set up local variables for easier access
    $ReleaseFullVersion = $Script:ReleaseDetails.FullVersion
    $ReleaseNotesFolderPath = $Script:PathVars.ReleaseNotesFolder 

    if (-Not (Test-Path $ReleaseNotesFolderPath)) {
        Write-Host "`nCreating the release-notes folder for release version $ReleaseFullVersion..."
        Start-Sleep $Script:SleepTimer
        New-Item -ItemType Directory -Name $ReleaseNotesFolderPath > $null
    }
    else {
        Write-Host "`nThere already exists a release-notes folder for release version $ReleaseFullVersion...skipping this step..."
        Start-Sleep $Script:SleepTimer
    }
}
function Add-PyToolContents {
    <#
    .SYNOPSIS
        Copies the necessary files to the py-tool folder for the release.

    .DESCRIPTION
        The `Add-PyToolContents` function copies the necessary files to the py-tool folder for the release. This includes the CompStart.py script and all the Python script dependencies from the devenv folder.

    .PARAMETER None
        This function does not take any parameters.

    .EXAMPLE
        Add-PyToolContents
        Copies the necessary files to the py-tool folder for the release version stored in the $Script:ReleaseDetails.FullVersion variable.

    .NOTES
        Author: David H. Watson (with help from VS Code Copilot)
        GitHub: @dEhiN
        Created: 2024-01-14
    #>

    # Before proceeding, make sure we are in the correct directory
    Set-Location $Script:PathVars.ReleasePyToolFolder 

    # Copy over the files and folder necessary to generate the Python executable
    Write-Host "`nCopying over the Python CLI tool and its dependencies to the $($Script:FolderNames.PyTool) folder..."
    Start-Sleep -Seconds $Script:SleepTimer

    Copy-Item -Path $Script:PathVars.DevCSPythonScript  -Destination $Script:PathVars.ReleasePyToolFolder 
    Copy-Item -Path $Script:PathVars.DevPythonDependenciesFolder -Destination $Script:PathVars.ReleasePyToolFolder 
    
    $AllPythonDependencies = "$($Script:PathVars.DevPythonDependenciesFolder)$($Script:OSSeparatorChar)*.py"
    Copy-Item -Path $AllPythonDependencies -Destination $Script:PathVars.ReleasePythonDependenciesFolder
}
function Copy-ReleaseContents {
    <#
    .SYNOPSIS
        Copies the necessary content for a release to the release folder.
    .DESCRIPTION
        The `Copy-ReleaseContents` function copies the necessary content for a release to the release folder. This includes the CompStart content, the release notes content, and the Python tool executable. The function first checks to ensure the release folder exists. If there is no release folder, the user is alerted and the script is exited. Next, the function copies the CompStart content, the release notes content, and the Python tool executable to the release folder.
    .PARAMETER None
        This function does not take any parameters.
    .EXAMPLE
        Copy-ReleaseContents
        Copies the necessary content for a release to the release folder for the release version stored in the $Script:ReleaseDetails.FullVersion variable.
    .NOTES
        Author: David H. Watson (with help from VS Code Copilot)
        GitHub: @dEhiN
        Created: 2024-01-14
    #>

    # Set up local variables for easier access
    $ReleaseFullVersion = $Script:ReleaseDetails.FullVersion

    # Before proceeding, set the location to the release folder and add the necessary subfolders
    Set-ReleaseFolderLocation
    Add-CompStartFolder
    Add-ReleaseNotesFolder

    # Copy the CompStart content
    Write-Host "`nPopulating the inner CompStart folder for release $ReleaseFullVersion..."
    Start-Sleep $Script:SleepTimer
    Copy-Item -Path $Script:PathVars.DevCSBatchScript  -Destination $$Script:PathVars.ReleasesInnerCSFolder 
    Copy-Item -Path $Script:PathVars.DevCSPowerShellScript -Destination $$Script:PathVars.ReleasesInnerCSFolder 
    Copy-Item -Path $Script:PathVars.DevConfigFolder -Destination $Script:PathVars.ReleasesInnerCSFolder  -Recurse -Force

    # Copy the CS installer content
    Write-Host "`nCopying over the installer script for release $ReleaseFullVersion..."
    Start-Sleep $Script:SleepTimer
    Copy-Item -Path $Script:PathVars.AssetInstallerPowerShellScript  -Destination $Script:PathVars.ReleasesOuterCSFolder

    # Copy the release notes content and instructions file
    Write-Host "`nCopying over the instructions and release notes README for release $ReleaseFullVersion..."
    Start-Sleep $Script:SleepTimer
    Copy-Item -Path $Script:PathVars.AssetReleaseNotesMarkdown  -Destination $Script:PathVars.ReleaseNotesFolder 
    Copy-Item -Path $Script:PathVars.AssetInstructionsText  -Destination $Script:PathVars.ReleaseInstallerFolder

    Exit

    # Deal with the Python executable
    $PyToolsPath = "$ReleaseFullPath\$PyToolsFolder"
    if (-Not (Test-Path $PyToolsPath)) {
        Write-Host "`nUnable to find a py-tools folder.`nPlease run the PowerShell script `GeneratePythonTool.ps1` before running this script..."
        Exit
    }
    $PyIDistPath = "$PyToolsPath\$PyIDistFolder"
    $CSPythonPath = "$PyIDistPath\$PythonExeFile"
    Write-Host "`nCopying over the Python tool executable for release $ReleaseFullVersion..."
    Start-Sleep $Script:SleepTimer
    Copy-Item -Path $CSPythonPath -Destination $CSFolderPath

    Write-Host "`nAll release content has been copied over successfully to $ReleaseFullPath"
}
function New-ReleasePackage {
    # The following code has been copied from the GenerateReleasePackage script:
    <#
# Before proceeding, confirm the release folder path exists and if not, alert the user to create it
if (-Not (Test-Path $ReleaseFullPath)) {
    Write-Host "`nThe release folder $ReleaseFullPath does not exist!`nPlease create the release folder before running this script..."
    Exit
}

$ReleaseCSFolderPath = "$ReleaseFullPath\$CompStartFolder"
$AssetInstructionsTextPath = "$ReleaseFullPath\$ReleaseInstructionsFile"

# Check if the release folder has the necessary folders and files
if (-Not (Test-Path $ReleaseCSFolderPath) -Or -Not (Test-Path $AssetInstructionsTextPath)) {
    Write-Host "`nThe release folder $ReleaseFullPath is missing necessary folders and files!`nPlease ensure the release folder has the following folders and files:`n- $CompStartFolder`n- $ReleaseNotesFolder`n- $ReleaseInstructionsFile`n"
    Exit
}

# Also check if the packages folder exists
if (-Not (Test-Path $PackageFullPath)) {
    Write-Host "`nThe package folder $PackageFullPath does not exist!`nIt will now be created..."

    Set-Location $PackageVersionsPath
    if (-Not (Test-Path $PackageMajorPath)) {
        Write-Host "`nCreating the package directory for release major version $ReleaseMajorVersion..."
        Start-Sleep $Script:SleepTimer
        New-Item -Name "v$ReleaseMajorVersion" -ItemType "directory" > $null
    }

    Set-Location $PackageMajorPath
    if (-Not (Test-Path $PackageMinorPath)) {
        Write-Host "`nCreating the package directory for release minor version $ReleaseMinorVersion..."
        Start-Sleep $Script:SleepTimer
        New-Item -Name "m$ReleaseMinorVersion" -ItemType "directory" > $null
    }
}
else {
    Write-Host "`nThe package folder $PackageFullPath already exists`n"
}

Set-Location $PackageFullPath

# Get the release package name
$ReleasePackageName = "CompStart-$ReleaseFullVersion.zip"

# Create the hash table object to pass to the Compress-Archive cmdlet
$PackageContents = @{
    Path             = $ReleaseCSFolderPath, $AssetInstructionsTextPath
    DestinationPath  = $ReleasePackageName
    CompressionLevel = "Optimal"
}

Write-Host "`nCreating the package artifact for release $ReleaseFullVersion..."
Start-Sleep $Script:SleepTimer
Compress-Archive @PackageContents > $null
#>
}

# Section: Main Script
# Set the starting directory to the project root
$SetCSSuccess = Set-ProjectRoot

# Check to make sure we are in the project root
if (-Not $SetCSSuccess) {
    # Inform user project root can't be found and the script is ending
    Write-Host "`nUnable to find project root. Quitting script..."
    Exit
}

# Store the full path of the project root
$Script:PathVars.ProjectRootFolder = Get-Location

# Get the details of the release to work with
Get-ReleaseDetails

# Update all the path variables to be used in the script
Update-PathVars

# Start the process to work on the release
Start-Release

# Section: Commented-out Copied Code
# Temporary holding place for copy-pasting of all the script variables needed for the script
<#
# Get the release package name
$ReleasePackageName = "CompStart-$ReleaseFullVersion.zip"

# Create the hash table object to pass to the Compress-Archive cmdlet
$PackageContents = @{
Path             = $ReleaseCSFolderPath, $AssetInstructionsTextPath
DestinationPath  = $ReleasePackageName
CompressionLevel = "Optimal"
}
#>

# Section: New release folder structure:
<#
> - <release-folder>
        | - CompStart (folder)
            | - install.ps1 (file)
            | - installer-files (folder)
                | - instructions.txt (file)
                | - CompStart (folder)
                    | - CompStart.ps1 (file)
                    | - CompStart.bat (file)
                    | - config (folder)
                        | - default_startup.json (file)
                        | - startup_data.json (file)
                        | - schema (folder)
                            | - startup_data.schema.json (file)
                            | - startup_item.schema.json (file)
        | - py-tool (folder)
            | - CompStart.py (file)
            | - CompStart.spec (file)
            | - build (folder) [PyInstaller specific build files]
            | - dist (folder)
                | - CompStart.exe (file)
            | - dependencies (folder)
                | - __init__.py (file)
                | - cs_chooser.py
                | - cs_data_generate.py
                | - cs_desc.py
                | - cs_enum.py
                | - cs_helper.py
                | - cs_jsonfn.py
                | - cs_pretty.py
                | - cs_startup_add.py
                | - cs_startup_edit.py
        | - release-notes (folder)
            | - release-notes.md (file)
#>