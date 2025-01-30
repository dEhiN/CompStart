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
    ReleaseNotesMarkdown      = "release-notes.md"

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
$Script:FullPaths = [ordered]@{    
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
    ReleaseOuterCSFolder            = ""
    ReleaseInnerCSFolder            = ""
    ReleasePyToolFolder             = ""
    ReleasePyIDistFolder            = ""
    ReleasePythonDependenciesFolder = ""
    ReleaseInstallerFolder          = ""
    ReleaseCSExecutable             = ""
}

# Section: Script Functions
function Start-ReleaseProcess {
    <#
    .SYNOPSIS
        Starts the release process.

    .DESCRIPTION
        The `Start-ReleaseProcess` function initiates the release process by going through the 4 major tasks involved:

        1. Set (up) the release folder structure for both the releases and packages directories
        2. Invoke the Python module `pyinstaller` to generate an executable from the CompStart Python script
        3. Copy the release-specific content from the devenv and the prodenv>assets folders to the release folder
        4. New release package - creates a new release package

        The function first gives the user a menu with a choice. The user can start the full release process as described in the 4 tasks, or perform each task separately. This will allow the user to skip tasks that may not be needed.

        The function loops through the menu until the user specifically quits. This allows the user to perform, for example, work on tasks 2 and 4, or 3 and 4, without having to go through the full release process each time.

    .PARAMETER None
        This function does not take any parameters.

    .EXAMPLE
        Start-ReleaseProcess
        Initiates the release process for whatever release details are stored in the $Script:ReleaseFullVersion variable.

    .NOTES
        Author: David H. Watson (with help from VS Code Copilot)
        GitHub: @dEhiN
        Created: 2025-01-04
        Updated: 2025-01-16
    #>

    # Function variables
    $UserMenu = "`nPlease choose one of the following:`n[1] Start the full release process`n[2] Set up the release folder structure`n[3] Generate the Python executable`n[4] Copy the contents needed for a release over to the release folder`n[5] Create a release package`n[6] Change the release details`n[Q] Quit`n`nWhat would you like to do? "
    $UserOptions = @("1", "2", "3", "4", "5", "Q")
    $ChoiceFullRelease = 1
    $ChoiceSetReleaseFolder = 2
    $ChoiceInvokePythonTool = 3
    $ChoiceCopyReleaseContents = 4
    $ChoiceNewReleasePackage = 5
    $ChoiceChangeReleaseDetails = 6
    $ChoiceQuit = "Q"

    # Loop until the user specifically quits
    do {
        $UserPrompt = ""

        # Loop until user answers prompt
        $InnerLoopTrue = $True
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
                $InnerLoopTrue = $False
            }
            else {
                Write-Host "Please make a valid choice!"
            }
        } while ($InnerLoopTrue -eq $True)

        # Set the release details if they are not already set or if the user chooses to change them
        if ((-Not $Script:ReleaseDetails.FullVersion) -or ($UserChoice -eq $ChoiceChangeReleaseDetails)) {
            Get-ReleaseDetails
            Update-PathVars
        }

        # Task 1
        if (($UserChoice -eq $ChoiceFullRelease) -or ($UserChoice -eq $ChoiceSetReleaseFolder)) {
            Set-ReleaseFolderStructure
            Set-ProjectRoot > $null
        }

        # Task 2
        if (($UserChoice -eq $ChoiceFullRelease) -or ($UserChoice -eq $ChoiceInvokePythonTool)) {
            Invoke-PythonTool
            Set-ProjectRoot > $null
        }

        # Task 3
        if (($UserChoice -eq $ChoiceFullRelease) -or ($UserChoice -eq $ChoiceCopyReleaseContents)) {
            Copy-ReleaseContents
            Set-ProjectRoot > $null
        }

        # Task 4
        if (($UserChoice -eq $ChoiceFullRelease) -or ($UserChoice -eq $ChoiceNewReleasePackage)) {
            New-ReleasePackage
            Set-ProjectRoot > $null
        }
    } while ($UserPrompt -ne $ChoiceQuit)
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
    $CurrLocation = Get-Location
    if ($CurrLocation -ne $Script:FullPaths.ReleasePyToolFolder) {
        Set-Location $Script:FullPaths.ReleasePyToolFolder
    }
    

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
        The `Update-PathVars` function sets and updates various path variables used throughout the project. It organizes paths for development, production, assets, packages, and releases based on the project root path and folder names. Specifically, it updates all the properties in the `$Script:FullPaths` dictionary.

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
    $ProjectRootPath = $Script:FullPaths.ProjectRootFolder 

    # First level folder paths
    $Script:FullPaths.DevFolder = "$ProjectRootPath$($Script:OSSeparatorChar)$($Script:FolderNames.DevEnv)"
    $Script:FullPaths.ProdFolder = "$ProjectRootPath$($Script:OSSeparatorChar)$($Script:FolderNames.ProdEnv)"

    # Dev related folder paths
    $DevPath = $Script:FullPaths.DevFolder 
    $Script:FullPaths.DevConfigFolder = "$DevPath$($Script:OSSeparatorChar)$($Script:FolderNames.Config)"
    $Script:FullPaths.DevPythonDependenciesFolder = "$DevPath$($Script:OSSeparatorChar)$($Script:FolderNames.PythonDependencies)"

    # Dev related file paths
    $Script:FullPaths.DevCSPythonScript = "$DevPath$($Script:OSSeparatorChar)$($Script:FileNames.CSPythonScript)"
    $Script:FullPaths.DevCSBatchScript = "$DevPath$($Script:OSSeparatorChar)$($Script:FileNames.CSBatchScript)"
    $Script:FullPaths.DevCSPowerShellScript = "$DevPath$($Script:OSSeparatorChar)$($Script:FileNames.CSPowerShellScript)"

    # Prod related folder paths
    $ProdPath = $Script:FullPaths.ProdFolder 
    $Script:FullPaths.AssetsFolder = "$ProdPath$($Script:OSSeparatorChar)$($Script:FolderNames.Assets)"
    $Script:FullPaths.PackagesFolder = "$ProdPath$($Script:OSSeparatorChar)$($Script:FolderNames.Packages)"
    $Script:FullPaths.ReleasesFolder = "$ProdPath$($Script:OSSeparatorChar)$($Script:FolderNames.Releases)"

    # Asset related folder paths
    $AssetsPath = $Script:FullPaths.AssetsFolder 
    $Script:FullPaths.AssetsReleaseFolder = "$AssetsPath$($Script:OSSeparatorChar)$($Script:FolderNames.ReleaseAssets)"
    $Script:FullPaths.AssetsInstallerFolder = "$AssetsPath$($Script:OSSeparatorChar)$($Script:FolderNames.InstallerAssets)"

    # Asset related file paths
    $CSInstallerPath = $Script:FullPaths.AssetsInstallerFolder
    $CSReleaseNotesPath = $Script:FullPaths.AssetsReleaseFolder
    $Script:FullPaths.AssetReleaseNotesMarkdown = "$($CSReleaseNotesPath)$($Script:OSSeparatorChar)$($Script:FileNames.ReleaseNotesMarkdown)"
    $Script:FullPaths.AssetInstructionsText = "$($CSReleaseNotesPath)$($Script:OSSeparatorChar)$($Script:FileNames.ReleaseInstructionsText)"
    $Script:FullPaths.AssetInstallerPowerShellScript = "$($CSInstallerPath)$($Script:OSSeparatorChar)$($Script:FileNames.InstallerPowerShellScript)"

    # Package related folder paths
    $PackagesPath = $Script:FullPaths.PackagesFolder 
    $Script:FullPaths.PackageMajorFolder = "$PackagesPath$($Script:OSSeparatorChar)$($Script:FolderNames.ReleaseMajorPrefix)$($Script:ReleaseDetails.MajorVersion)"
    $PackageMajorPath = $Script:FullPaths.PackageMajorFolder 
    $Script:FullPaths.PackageMinorFolder = "$PackageMajorPath$($Script:OSSeparatorChar)$($Script:FolderNames.ReleaseMinorPrefix)$($Script:ReleaseDetails.MinorVersion)"

    # Release related parent folder paths
    $ReleasesPath = $Script:FullPaths.ReleasesFolder
    $Script:FullPaths.ReleaseMajorFolder = "$ReleasesPath$($Script:OSSeparatorChar)$($Script:FolderNames.ReleaseMajorPrefix)$($Script:ReleaseDetails.MajorVersion)"
    $ReleaseMajorPath = $Script:FullPaths.ReleaseMajorFolder 
    $Script:FullPaths.ReleaseMinorFolder = "$ReleaseMajorPath$($Script:OSSeparatorChar)$($Script:FolderNames.ReleaseMinorPrefix)$($Script:ReleaseDetails.MinorVersion)"
    $ReleaseMinorPath = $Script:FullPaths.ReleaseMinorFolder 
    $Script:FullPaths.ReleaseFullFolder = "$ReleaseMinorPath$($Script:OSSeparatorChar)$($Script:ReleaseDetails.FullVersion)"

    # Release specific child folder paths: CompStart
    $ReleaseFullPath = $Script:FullPaths.ReleaseFullFolder
    $Script:FullPaths.ReleaseOuterCSFolder = "$ReleaseFullPath$($Script:OSSeparatorChar)$($Script:FolderNames.CompStart)"
    $ReleaseOuterCSPath = $Script:FullPaths.ReleaseOuterCSFolder
    $Script:FullPaths.ReleaseInstallerFolder = "$ReleaseOuterCSPath$($Script:OSSeparatorChar)$($Script:FolderNames.InstallerFiles)"
    $ReleaseInstallerPath = $Script:FullPaths.ReleaseInstallerFolder
    $Script:FullPaths.ReleaseInnerCSFolder = "$ReleaseInstallerPath$($Script:OSSeparatorChar)$($Script:FolderNames.CompStart)"

    # Release specific child folder paths: py-tool
    $Script:FullPaths.ReleasePyToolFolder = "$ReleaseFullPath$($Script:OSSeparatorChar)$($Script:FolderNames.PyTool)"
    $ReleasePyToolFolderPath = $Script:FullPaths.ReleasePyToolFolder 
    $Script:FullPaths.ReleasePythonDependenciesFolder = "$ReleasePyToolFolderPath$($Script:OSSeparatorChar)$($Script:FolderNames.PythonDependencies)"
    $Script:FullPaths.ReleasePyIDistFolder = "$ReleasePyToolFolderPath$($Script:OSSeparatorChar)$($Script:FolderNames.PyIDist)"

    # Release specific child file paths
    $ReleasePyIDistPath = $Script:FullPaths.ReleasePyIDistFolder
    $Script:FullPaths.ReleaseCSExecutable = "$ReleasePyIDistPath$($Script:OSSeparatorChar)$($Script:FileNames.CSPythonExe)"

    # Release specific child folder paths: release-notes
    $Script:FullPaths.ReleaseNotesFolder = "$ReleaseFullPath$($Script:OSSeparatorChar)$($Script:FolderNames.ReleaseNotes)"
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

    if (-Not (Test-Path $Script:FullPaths.ReleaseFullFolder)) {
        Write-Host "`nCannot find a release folder for release version $ReleaseFullVersion)!`nPlease create it first...exiting the script..."
        Exit
    }
    else {
        Write-Host "`nFound the release folder for release version $ReleaseFullVersion...continuing with the release process..."
        Start-Sleep $Script:SleepTimer
        Set-Location $Script:FullPaths.ReleaseFullFolder
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
    $PackageMajorPath = $Script:FullPaths.PackageMajorFolder 
    $ReleaseMajorPath = $Script:FullPaths.ReleaseMajorFolder 

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
    $PackageMinorPath = $Script:FullPaths.PackageMinorFolder 
    $ReleaseMinorPath = $Script:FullPaths.ReleaseMinorFolder 

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
    $ReleaseFullPath = $Script:FullPaths.ReleaseFullFolder

    # Check the releases directory
    if (-Not (Test-Path $ReleaseFullPath)) {
        Write-Host "`nCannot find a release folder for release version $ReleaseFullVersion..."
        Add-FullVersionFolder
    }
    else {
        Write-Host "`nThere already exists a release folder for release version $ReleaseFullVersion...skipping this step..."
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
        $MajorPath = $Script:FullPaths.PackageMajorFolder 
        $DirType = "package"
    }
    else {
        $MajorPath = $Script:FullPaths.ReleaseMajorFolder 
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
        $MinorPath = $Script:FullPaths.PackageMinorFolder 
        $DirType = "package"
    }
    else {
        $MinorPath = $Script:FullPaths.ReleaseMinorFolder 
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
    $ReleaseFullPath = $Script:FullPaths.ReleaseFullFolder
        
    Write-Host "Creating a release folder for release version $ReleaseFullVersion..."
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
    $ReleaseFullPath = $Script:FullPaths.ReleaseFullFolder
    $ReleasesOuterCSPath = $Script:FullPaths.ReleaseOuterCSFolder 
    $ReleaseInstallerPath = $Script:FullPaths.ReleaseInstallerFolder
    $ReleaseInnerCSPath = $Script:FullPaths.ReleaseInnerCSFolder

    # Create the outer CompStart folder
    if (-Not (Test-Path $ReleasesOuterCSPath)) {
        Write-Host "`nCreating the outer CompStart folder for release version $ReleaseFullVersion..."
        Start-Sleep $Script:SleepTimer
        New-Item -ItemType Directory -Name $Script:FolderNames.CompStart -Path $ReleaseFullPath  > $null
    }
    else {
        Write-Host "`nThere already exists an outer CompStart folder for release version $ReleaseFullVersion...skipping this step..."
        Start-Sleep $Script:SleepTimer
    }

    # Create the installer-files folder
    if (-Not (Test-Path $ReleaseInstallerPath)) {
        Write-Host "`nCreating the installer-files folder for release version $ReleaseFullVersion..."
        Start-Sleep $Script:SleepTimer
        New-Item -ItemType Directory -Name $Script:FolderNames.InstallerFiles -Path $ReleasesOuterCSPath > $null
    }
    else {
        Write-Host "`nThere already exists an installer-files folder for release version $ReleaseFullVersion...skipping this step..."
        Start-Sleep $Script:SleepTimer
    }

    # Create the inner CompStart folder
    if (-Not (Test-Path $ReleaseInnerCSPath)) {
        Write-Host "`nCreating the inner CompStart folder for release version $ReleaseFullVersion..."
        Start-Sleep $Script:SleepTimer
        New-Item -ItemType Directory -Name $Script:FolderNames.CompStart -Path $ReleaseInstallerPath > $null
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
    $PyToolFolderPath = $Script:FullPaths.ReleasePyToolFolder 
    
    # Confirm if the py-tool folder path exists and if not, try to create it
    if (-Not (Test-Path $PyToolFolderPath)) {
        Write-Host "`nCannot find a $PyToolFolder folder in the release folder for release version $($Script:ReleaseDetails.FullVersion)."
        Write-Host "Creating the $PyToolFolder folder..."
        Write-Host "...at $($Script:FullPaths.ReleaseFullFolder)"
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
    $ReleaseNotesFolderPath = $Script:FullPaths.ReleaseNotesFolder
    $ReleaseFullPath = $Script:FullPaths.ReleaseFullFolder 

    if (-Not (Test-Path $ReleaseNotesFolderPath)) {
        Write-Host "`nCreating the release-notes folder for release version $ReleaseFullVersion..."
        Start-Sleep $Script:SleepTimer
        New-Item -ItemType Directory -Name $Script:FolderNames.ReleaseNotes -Path $ReleaseFullPath > $null
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
    Set-Location $Script:FullPaths.ReleasePyToolFolder 

    # Copy over the files and folder necessary to generate the Python executable
    Write-Host "`nCopying over the Python CLI tool and its dependencies to the $($Script:FolderNames.PyTool) folder..."
    Start-Sleep -Seconds $Script:SleepTimer

    Copy-Item -Path $Script:FullPaths.DevCSPythonScript  -Destination $Script:FullPaths.ReleasePyToolFolder 
    Copy-Item -Path $Script:FullPaths.DevPythonDependenciesFolder -Destination $Script:FullPaths.ReleasePyToolFolder 
    
    $AllPythonDependencies = "$($Script:FullPaths.DevPythonDependenciesFolder)$($Script:OSSeparatorChar)*.py"
    Copy-Item -Path $AllPythonDependencies -Destination $Script:FullPaths.ReleasePythonDependenciesFolder
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
    Copy-Item -Path $Script:FullPaths.DevCSBatchScript  -Destination $Script:FullPaths.ReleaseInnerCSFolder 
    Copy-Item -Path $Script:FullPaths.DevCSPowerShellScript -Destination $Script:FullPaths.ReleaseInnerCSFolder 
    Copy-Item -Path $Script:FullPaths.DevConfigFolder -Destination $Script:FullPaths.ReleaseInnerCSFolder  -Recurse -Force

    # Copy the CS installer content
    Write-Host "`nCopying over the installer script for release $ReleaseFullVersion..."
    Start-Sleep $Script:SleepTimer
    Copy-Item -Path $Script:FullPaths.AssetInstallerPowerShellScript  -Destination $Script:FullPaths.ReleaseOuterCSFolder

    # Copy the release notes content and instructions file
    Write-Host "`nCopying over the instructions and release notes README for release $ReleaseFullVersion..."
    Start-Sleep $Script:SleepTimer
    Copy-Item -Path $Script:FullPaths.AssetReleaseNotesMarkdown  -Destination $Script:FullPaths.ReleaseNotesFolder 
    Copy-Item -Path $Script:FullPaths.AssetInstructionsText  -Destination $Script:FullPaths.ReleaseInstallerFolder

    # Deal with the Python executable
    if (-Not (Test-Path $Script:FullPaths.ReleasePyToolFolder)) {
        Write-Host "`nUnable to find a py-tools folder.`nPlease run the PowerShell script `GeneratePythonTool.ps1` before running this script..."
        Exit
    }
    Write-Host "`nCopying over the Python tool executable for release $ReleaseFullVersion..."
    Start-Sleep $Script:SleepTimer
    Copy-Item -Path $Script:FullPaths.ReleaseCSExecutable -Destination $Script:FullPaths.ReleaseInnerCSFolder

    Write-Host "`nAll release content has been copied over successfully for release $ReleaseFullVersion ..."
}
function New-ReleasePackage {
    # Before proceeding, set the location to the release folder
    Set-ReleaseFolderLocation

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
$Script:FullPaths.ProjectRootFolder = Get-Location

# Start the process to work on the release
Start-ReleaseProcess

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