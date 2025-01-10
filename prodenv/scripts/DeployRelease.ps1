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

# Misc script variables
$Script:SleepTime = 2
$Script:DefRetValue = $false
$Script:OSSeparatorChar = [System.IO.Path]::DirectorySeparatorChar

# Path related script variables
$Script:PathVars = [ordered]@{    
    InstallationLocationParent = [System.Environment]::GetFolderPath('LocalApplicationData')
}

# Folder names script variables
$Script:FolderNames = [ordered]@{
    CompStart          = "CompStart"
    InstallerFiles     = "installer-files"
    DevEnv             = "devenv"
    Config             = "config"
    PythonDependencies = "dependencies"
    ProdEnv            = "prodenv"
    Releases           = "releases"
    Packages           = "packages"
    Assets             = "assets"
    ReleaseAssets      = "release-assets"
    CSInstaller        = "cs-installer"
    PyTool             = "py-tool"
    PyInstaller        = "pyinstaller"
    PyIDist            = "dist"
}

# File names script variables
$Script:FileNames = [ordered]@{
    CSBatchScript           = "CompStart.bat"
    CSPowerShellScript      = "CompStart.ps1"
    CSPythonScript          = "CompStart.py"
    CSPythonExe             = "CompStart.exe"
    InstallPowerShellScript = "install.ps1"
    ReleaseInstructions     = "instructions.txt"
    ReleaseNotesMD          = "release_notes.md"
}

# Release details script variables
$Script:ReleaseDetails = [ordered]@{
    MajorVersion = ""
    MinorVersion = ""
    Tag          = ""
}

# Temporary holding place for copy-pasting of all the script variables needed for the script
<#
# Initialize the variables to be used in the script
$ReleaseVersionsPath = "$ProjectRootPath\$ReleasesFolder\$ReleaseVersionsFolder"

# Store the release subfolder paths
$ReleaseMajorPath = "$ReleaseVersionsPath\v$ReleaseMajorVersion"
$ReleaseMinorPath = "$ReleaseMajorPath\m$ReleaseMinorVersion"
$ReleaseFullPath = "$ReleaseMinorPath\$ReleaseFullVersion"

# Create the paths to be used in the script
$ReleasesPath = "$ProjectRootPath\$ReleasesFolder"
$ReleaseVersionsPath = "$ReleasesPath\$ReleaseVersionsFolder"
$DevPath = "$ProjectRootPath\$DevFolder"
$CSPath = "$DevPath\$CSScript"
$DependenciesPath = "$DevPath\$DependenciesFolder"

# Initialize the pyinstaller specific variables
$PyIArgumentArray = @(
    $CSPath,
    "--onefile"
)

# Store the release subfolder paths
$ReleaseMajorPath = "$ReleaseVersionsPath\v$ReleaseMajorVersion"
$ReleaseMinorPath = "$ReleaseMajorPath\m$ReleaseMinorVersion"
$ReleaseFullPath = "$ReleaseMinorPath\$ReleaseFullVersion"

# Set the folder for the PyInstaller generated content
$PyInstallerPath = "$ReleaseFullPath\$PyToolsFolder"

# Create the devenv paths to be used in the script
$DevPath = "$ProjectRootPath\$DevFolder"
$ConfigPath = "$DevPath\$ConfigFolder"
$CSFolderPath = ""
$CSPowerShellPath = "$DevPath\$PowerShellScriptFile"
$CSBatchPath = "$DevPath\$BatchScriptFile"

# Create the release paths to be used in the script
$ReleasesPath = "$ProjectRootPath\$ReleasesFolder"
$ReleaseVersionsPath = "$ReleasesPath\$ReleaseVersionsFolder"
$ReleaseTemplatesPath = "$ReleasesPath\$ReleaseTemplatesFolder"
$ReleaseNotesFolderPath = ""
$ReleaseNotesMDPath = "$ReleaseTemplatesPath\$ReleaseNotesMDFile"
$ReleaseInstructionsPath = "$ReleaseTemplatesPath\$ReleaseInstructionsFile"

# Create the PyInstaller specific variables to be used in the script
$PyToolsPath = ""
$PyIDistPath = ""
$CSPythonPath = ""

# Store the release subfolder paths
$ReleaseMajorPath = "$ReleaseVersionsPath\v$ReleaseMajorVersion"
$ReleaseMinorPath = "$ReleaseMajorPath\m$ReleaseMinorVersion"
$ReleaseFullPath = "$ReleaseMinorPath\$ReleaseFullVersion"

# Initialize the static variables to be used in the script
$ReleasesPath = "$ProjectRootPath\$ReleasesFolder"
$PackagesPath = "$ProjectRootPath\$PackagesFolder"
$PackageVersionsPath = "$PackagesPath\$PackageVersionsFolder"
$ReleaseVersionsPath = "$ReleasesPath\$ReleaseVersionsFolder"

# Store the release and package subfolder paths
$ReleaseMajorPath = "$ReleaseVersionsPath\v$ReleaseMajorVersion"
$PackageMajorPath = "$PackageVersionsPath\v$ReleaseMajorVersion"
$ReleaseMinorPath = "$ReleaseMajorPath\m$ReleaseMinorVersion"
$PackageMinorPath = "$PackageMajorPath\m$ReleaseMinorVersion"
$ReleaseFullPath = "$ReleaseMinorPath\$ReleaseFullVersion"
$PackageFullPath = $PackageMinorPath
#>

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

        .OUTPUTS
        [bool] Value specifying if the folder to check for was found on the current working directory path. Essentially scenarios 2-5 above will return True while scenario 1 will return False. It will be assumed that if this function returns true, then the function Set-Location has been used to move the current working directory to the desired location.

        .EXAMPLE
        Set-StartDirectory
        Checks if the directory "CompStart" is in the current working directory path and sets the location to it if found.

        .NOTES
        Author: David H. Watson (with help from VS Code Copilot)
        GitHub: @dEhiN
        Created: 2025-01-04
        Updated: 2025-01-10
    #>

    # Initialize function variables
    $ReturnValue = $Script:DefRetValue
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

function Add-MajorVersionFolder {
    <#
        .SYNOPSIS
        Creates a directory for a major release version.

        .DESCRIPTION
        The `Add-MajorVersionFolder` function creates a directory for a major release version at the specified location.

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
        Created: 2024-12-30
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

function Add-MinorVersionFolder {
    <#
        .SYNOPSIS
        Creates a directory for a minor release version.

        .DESCRIPTION
        The `Add-MinorVersionFolder` function creates a directory for a minor release version at the specified location.

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
        Created: 2024-12-30
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

function Add-ReleaseVersionFolder {
    <#
        .SYNOPSIS
        Creates a directory for a release version.

        .DESCRIPTION
        The `Add-ReleaseVersionFolder` function creates a directory for a release version at the specified location.

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
        Created: 2024-12-30
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

function Set-MajorVersionPath {
    <#
        .SYNOPSIS
        Checks for an existing major release version folder and creates one if applicable.

        .DESCRIPTION
        The `Set-MajorVersionPath` function checks both the releases and packages folders to see if there is already a subfolder for the major version given as a parameter. If there isn't one, then it will create one.

        .PARAMETER MajorVersion
        The major version of the release.

        .EXAMPLE
        Set-MajorVersionPath -MajorVersion "1"
        Checks to see if there's a folder called "v1" at /prodenv/releases/ and /prodenv/packages/, and create it if it doesn't exist.

        .NOTES
        Author: David H. Watson (with help from VS Code Copilot)
        GitHub: @dEhiN
        Created: 2025-01-04
    #>
    
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]
        $MajorVersion
    )

    if (-Not (Test-Path $ReleaseMajorPath)) {
        Write-Host "`nCannot find a directory for the release major version $ReleaseMajorVersion..."
        Add-MajorVersionFolder $ReleaseMajorVersion $ReleaseMajorPath
    }
    else {
        Write-Host "`nThere already exists a release major version $ReleaseMajorVersion folder...skipping this step..."
        Start-Sleep $Script:SleepTime
    }

}

function Set-MinorVersionPath {
    <#
        .SYNOPSIS
        Checks for an existing minor release version folder and creates one if applicable.

        .DESCRIPTION
        The `Set-MinorVersionPath` function checks both the releases and packages folders to see if there is already a subfolder for the minor version given as a parameter. If there isn't one, then it will create one.

        .PARAMETER MajorVersion
        The major version of the release.

        .PARAMETER MinorVersion
        The minor version of the release.

        .EXAMPLE
        Set-MinorVersionPath -MajorVersion "1" -MinorVersion "1"
        Checks to see if there's a folder called "m1" at /prodenv/releases/v1 and /prodenv/packages/v1, and create it if it doesn't exist.

        .NOTES
        Author: David H. Watson (with help from VS Code Copilot)
        GitHub: @dEhiN
        Created: 2025-01-04
    #>
    
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]
        $MajorVersion,
        [Parameter(Mandatory)]
        [string]
        $MinorVersion
    )

    if (-Not (Test-Path $ReleaseMinorPath)) {
        Write-Host "`nCannot find a directory for the release minor version $ReleaseMinorVersion..."
        Add-MinorVersionFolder $ReleaseMinorVersion $ReleaseMinorPath
    }
    else {
        Write-Host "`nThere already exists a release minor version $ReleaseMinorVersion folder...skipping this step..."
        Start-Sleep $Script:SleepTime
    }
}

function Set-ReleasePath {
    <#
        .SYNOPSIS
        Checks for an existing release folder and creates one if applicable.

        .DESCRIPTION
        The `Set-ReleasePath` function checks the releases folder to see if there is already a subfolder for the release version given as a parameter. If there isn't one, then it will create one.

        .PARAMETER ReleaseVersion
        The release full version

        .EXAMPLE
        Set-ReleasePath -ReleaseVersion "1.1-alpha"
        Checks to see if there's a folder called "1.1-alpha" at /prodenv/releases/v1/m1, and create it if it doesn't exist.

        .NOTES
        Author: David H. Watson (with help from VS Code Copilot)
        GitHub: @dEhiN
        Created: 2025-01-04
    #>
    
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]
        $ReleaseVersion
    )

    if (-Not (Test-Path $ReleaseFullPath)) {
        Write-Host "`nCannot find a directory for the release $ReleaseFullVersion..."
        Add-ReleaseVersionFolder $ReleaseFullVersion $ReleaseFullPath
    }
    else {
        Write-Host "`nThere already exists a release $ReleaseFullVersion folder...skipping this step..."
        Start-Sleep $Script:SleepTime
    }
}

function Start-Release {
    <#
        .SYNOPSIS
        Starts the release process.

        .DESCRIPTION
        The `Start-Release` function initiates the release process by creating the necessary directories for the release.

        .EXAMPLE
        Start-Release
        Initiates the release process for whatever release details are stored in the $Script:ReleaseFullVersion variable.

        .NOTES
        Author: David H. Watson (with help from VS Code Copilot)
        GitHub: @dEhiN
        Created: 2025-01-04
        Updated: 2025-01-10
    #>
    
    # Deal with the major release version
    # Set-MajorVersionPath -MajorVersion $ReleaseMajorVersion

    # Deal with the minor release version
    # Set-MinorVersionPath -MajorVersion $ReleaseMajorVersion -MinorVersion $ReleaseMinorVersion

    # Deal with the release folder
    # Set-ReleasePath -ReleaseVersion $ReleaseFullVersion
}

function Get-ReleaseDetails {
    <#
        .SYNOPSIS
        Gets the release details from the user.

        .DESCRIPTION
        The `Get-ReleaseDetails` function prompts the user for the release details, including the major version, minor version, and release tag.

        .EXAMPLE
        Get-ReleaseDetails
        Prompts the user for the release details.

        .NOTES
        Author: David H. Watson (with help from VS Code Copilot)
        GitHub: @dEhiN
        Created: 2025-01-10
    #>
    Write-Host "`nWhat is the release major version number? " -NoNewline
    $Script:ReleaseDetails.MajorVersion = $Host.UI.ReadLine()

    Write-Host "What is the release minor version number? " -NoNewline
    $Script:ReleaseDetails.MinorVersion = $Host.UI.ReadLine()

    $Script:ReleaseDetails.Add("FullVersion", "$($Script:ReleaseDetails.MajorVersion).$($Script:ReleaseDetails.MinorVersion)")

    Write-Host "What is the release tag for version $($Script:ReleaseDetails.FullVersion) (or leave blank if there is none)? " -NoNewline
    $Script:ReleaseDetails.Tag = $Host.UI.ReadLine()

    if ($Script:ReleaseDetails.Tag) {
        $Script:ReleaseDetails.FullVersion += "-$($Script:ReleaseDetails.Tag)"
    }
    
}

# Start of the main script

# Set the starting directory to the project root
$SetCSSuccess = Set-ProjectRoot

# Check to make sure we are in the project root
if (-Not $SetCSSuccess) {
    # Inform user project root can't be found and the script is ending
    Write-Host "`nUnable to find project root. Quitting script..."
    Exit
}

# Get the location of the release folder root
$ProjectRootPath = Get-Location
Write-Host "`nProject root path: $ProjectRootPath"

Get-ReleaseDetails

Start-Release

# The following code has been copied from the GeneratePythonTool script:
<#
# Before proceeding, confirm the release folder path exists and if not, alert the user to create it
if (-Not (Test-Path $ReleaseFullPath)) {
    Write-Host "`nThe release folder $ReleaseFullPath does not exist!`nPlease run the PowerShell script 'CreateReleaseFolder.ps1' before running this script..."
    Exit
}

# Before proceeding, confirm if the py-tools path exists and if not, try to create it
if (-Not (Test-Path $PyInstallerPath)) {
    # Create the PyInstaller folder
    Write-Host "`nCreating directory $PyInstallerPath..."
    Start-Sleep -Seconds 1
    New-Item $PyInstallerPath -ItemType Directory > $null
}

Set-Location $PyInstallerPath

# Check to see if there's anything already in the PyInstaller folder and if so, delete it
if ((Get-ChildItem $PyInstallerPath).Length -gt 0) {
    Write-Host "`nFound items in the py-tools folder. Deleting all items..."
    # Loop until there's nothing in py-tools
    $LoopTrue = $true
    do {
        Get-ChildItem -Path $PyInstallerPath -Recurse | ForEach-Object {
            if ($_.GetType() -eq [System.IO.FileInfo]) {
                Remove-Item $_
            }
            elseif (($_.GetType() -eq [System.IO.DirectoryInfo]) -and ((Get-ChildItem $_).Length -eq 0)) {
                $LoopTrue = $false
                continue
            }
        }
    } while ($LoopTrue -eq $true)
    # Set-Location $PyInstallerPath
    # Start-Process -FilePath "cmd.exe" -ArgumentList "for /D %v in (*) do rd /s/q %v" -NoNewWindow
    Write-Host "The folder is now empty."
}

# Copy over the files and folder necessary to generate the Python executable
Write-Host "`nCopying over the Python CLI tool and its dependencies to the $PyToolsFolder folder..."
Start-Sleep $Script:SleepTime
if ((Get-ChildItem $PyInstallerPath).Length -eq 0) {
    Copy-Item -Path $DependenciesPath -Destination $PyInstallerPath
}
Copy-Item -Path $CSPath -Destination $PyInstallerPath
Copy-Item -Path $DependenciesPath\*.py -Destination $PyInstallerPath\dependencies

# Let user know the Python executable will be created and count down for 5 seconds
Write-Host "`nCreating Python executable in..."
for ($counter = 5; $counter -gt 0; $counter--) {
    Write-Host "$counter..."
    Start-Sleep -Seconds 1
}

# Create the Python executable: pyinstaller .\CompStart.py --onefile
Start-Process -FilePath $PyIFilePath -ArgumentList $PyIArgumentArray -NoNewWindow -Wait
Write-Host "`nPython executable successfully created"
#>

# The following code has been copied from the CopyReleaseContent script:
<#
# Before proceeding, confirm the release folder path exists and if not, alert the user to create it
if (-Not (Test-Path $ReleaseFullPath)) {
    Write-Host "`nThe release folder $ReleaseFullPath does not exist!`nPlease run the PowerShell script 'CreateReleaseFolder.ps1' before running this script..."
    Exit
}

Set-Location $ReleaseFullPath

# Create the CompStart folder for the release, if needed, and update the appropriate path variable
if (-Not (Test-Path $CompStartFolder)) {
    Write-Host "`nCreating the CompStart folder for release $ReleaseFullVersion..."
    Start-Sleep $Script:SleepTime
    New-Item -ItemType Directory -Name $CompStartFolder > $null
}
else {
    Write-Host "`nThere already exists a CompStart folder for release $ReleaseFullVersion...skipping this step..."
    Start-Sleep $Script:SleepTime
}
$CSFolderPath = "$ReleaseFullPath\$CompStartFolder"

# Create the release notes folder for the release, if needed, and update the appropriate path variable
if (-Not (Test-Path $ReleaseNotesFolder)) {
    Write-Host "`nCreating the release-notes folder for release $ReleaseFullVersion..."
    Start-Sleep $Script:SleepTime
    New-Item -ItemType Directory -Name $ReleaseNotesFolder > $null
}
else {
    Write-Host "`nThere already exists a release-notes folder for release $ReleaseFullVersion...skipping this step..."
    Start-Sleep $Script:SleepTime
}
$ReleaseNotesFolderPath = "$ReleaseFullPath\$ReleaseNotesFolder"

# Copy the CompStart content
Write-Host "`nPopulating the CompStart folder for release $ReleaseFullVersion..."
Start-Sleep $Script:SleepTime
Copy-Item -Path $CSBatchPath -Destination $CSFolderPath
Copy-Item -Path $CSPowerShellPath -Destination $CSFolderPath
Copy-Item -Path $ConfigPath -Destination $CSFolderPath -Recurse -Force

# Copy the release notes content and instructions file
Write-Host "`nCopying over the instructions and release notes README for release $ReleaseFullVersion..."
Start-Sleep $Script:SleepTime
Copy-Item -Path $ReleaseNotesMDPath -Destination $ReleaseNotesFolderPath
Copy-Item -Path $ReleaseInstructionsPath -Destination $FullReleasesPath

# Deal with the Python executable
$PyToolsPath = "$ReleaseFullPath\$PyToolsFolder"
if (-Not (Test-Path $PyToolsPath)) {
    Write-Host "`nUnable to find a py-tools folder.`nPlease run the PowerShell script `GeneratePythonTool.ps1` before running this script..."
    Exit
}
$PyIDistPath = "$PyToolsPath\$PyIDistFolder"
$CSPythonPath = "$PyIDistPath\$PythonExeFile"
Write-Host "`nCopying over the Python tool executable for release $ReleaseFullVersion..."
Start-Sleep $Script:SleepTime
Copy-Item -Path $CSPythonPath -Destination $CSFolderPath

Write-Host "`nAll release content has been copied over successfully to $ReleaseFullPath"
#>

# The following code has been copied from the GenerateReleasePackage script:
<#
# Before proceeding, confirm the release folder path exists and if not, alert the user to create it
if (-Not (Test-Path $ReleaseFullPath)) {
    Write-Host "`nThe release folder $ReleaseFullPath does not exist!`nPlease create the release folder before running this script..."
    Exit
}

$ReleaseCSFolderPath = "$ReleaseFullPath\$CompStartFolder"
$ReleaseInstructionsPath = "$ReleaseFullPath\$ReleaseInstructionsFile"

# Check if the release folder has the necessary folders and files
if (-Not (Test-Path $ReleaseCSFolderPath) -Or -Not (Test-Path $ReleaseInstructionsPath)) {
    Write-Host "`nThe release folder $ReleaseFullPath is missing necessary folders and files!`nPlease ensure the release folder has the following folders and files:`n- $CompStartFolder`n- $ReleaseNotesFolder`n- $ReleaseInstructionsFile`n"
    Exit
}

# Also check if the packages folder exists
if (-Not (Test-Path $PackageFullPath)) {
    Write-Host "`nThe package folder $PackageFullPath does not exist!`nIt will now be created..."

    Set-Location $PackageVersionsPath
    if (-Not (Test-Path $PackageMajorPath)) {
        Write-Host "`nCreating the package directory for release major version $ReleaseMajorVersion..."
        Start-Sleep $Script:SleepTime
        New-Item -Name "v$ReleaseMajorVersion" -ItemType "directory" > $null
    }

    Set-Location $PackageMajorPath
    if (-Not (Test-Path $PackageMinorPath)) {
        Write-Host "`nCreating the package directory for release minor version $ReleaseMinorVersion..."
        Start-Sleep $Script:SleepTime
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
    Path             = $ReleaseCSFolderPath, $ReleaseInstructionsPath
    DestinationPath  = $ReleasePackageName
    CompressionLevel = "Optimal"
}

Write-Host "`nCreating the package artifact for release $ReleaseFullVersion..."
Start-Sleep $Script:SleepTime
Compress-Archive @PackageContents > $null
#>