# PowerShell script to automate the generation of the Python command line tool CompStart.py to an executable using the Python module PyInstaller. This script is meant to be used for releases and will assume the release folder has been created. As a result, only a "py-tool" folder will be created where everything will be copied and worked on.

# Get the location of the release folder root
$ProjectRootPath = Get-Location

# Check to make sure we are in the project root
if (-Not (Select-String -InputObject $ProjectRootPath -Pattern "CompStart" -CaseSensitive)) {
    # Inform user project root can't be found and the script is ending
    Write-Host "`nUnable to find project root. Quitting script..."
    Exit
}

# Initialize the relevant folder and file variables to be used in the script
$ReleasesFolder = "releases"
$ReleaseVersionsFolder = "release-versions"
$DevFolder = "devenv"
$DependenciesFolder = "dependencies"
$PyToolsFolder = "py-tools"
$CSScript = "CompStart.py"
$FullReleaseVersion = ""

# Create the paths to be used in the script
$ReleasePath = "$ProjectRootPath\$ReleasesFolder\$ReleaseVersionsFolder"
$DevPath = "$ProjectRootPath\$DevFolder"
$CSPath = "$DevPath\$CSScript"
$DependenciesPath = "$DevPath\$DependenciesFolder"

# Initialize the pyinstaller specific variables
$PyIFilePath = "pyinstaller"
$PyIArgumentArray = @(
    $CSPath,
    "--onefile"
)

# Determine which version number we are working with
Write-Host "`nWhat is the release major version number? " -NoNewline
$ReleaseMajorVersion = $Host.UI.ReadLine()

Write-Host "What is the release minor version number? " -NoNewline
$ReleaseMinorVersion = $Host.UI.ReadLine()

Write-Host "What is the release tag for v$ReleaseMajorVersion.$ReleaseMinorVersion (or leave blank if there is none)? " -NoNewline
$ReleaseTag = $Host.UI.ReadLine()

$FullReleaseVersion = "$ReleaseMajorVersion.$ReleaseMinorVersion"

# Add the release tag if one exists
if ($ReleaseTag -ne "") {
    $FullReleaseVersion += "-$ReleaseTag"
}

# Determine the full path to the release directory we are working with
$FullReleasePath = "$ReleaseVersionsPath\v$ReleaseMajorVersion\m$ReleaseMinorVersion\$FullReleaseVersion"

# Set the folder for the PyInstaller generated content
$PyInstallerPath = "$FullReleasePath\$PyToolsFolder"

# Before proceeding, confirm the release folder path exists and if not, alert the user to create it
if (-Not (Test-Path $FullReleasePath)) {
    Write-Host "`nThe release folder $FullReleasePath does not exist!`nPlease run the PowerShell script 'CreateReleaseFolder.ps1' before running this script..."
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

# Change the working directory back to the project root
Set-Location $ProjectRootPath