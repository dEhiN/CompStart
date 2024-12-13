# PowerShell script to automate the generation of the Python command line tool CompStart.py to an executable using the Python module PyInstaller. This script is meant to be used for releases and will assume the release folder has been created. As a result, only a "py-tool" folder will be created where everything will be copied and worked on.

# Get the location of the release folder root
$ProjectRootPath = Get-Location

# Check to make sure we are in the project root
if (-Not (Select-String -InputObject $ProjectRootPath -Pattern "CompStart" -CaseSensitive)) {
    # Inform user project root can't be found and the script is ending
    Write-Host "Unable to find project root. Quitting script..."
    Exit
}

# Initialize the relevant folder and file variables to be used in the script
$ReleasesFolder = "releases"
$DevFolder = "devenv"
$DependenciesFolder = "dependencies"
$CSScript = "CompStart.py"

# Create the paths to be used in the script
$ReleasesPath = "$ProjectRootPath\$ReleasesFolder"
$DevPath = "$ProjectRootPath\$DevFolder"
$CSPath = "$DevPath\$CSScript"
$DependenciesPath = "$DevPath\$DependenciesFolder"

# Determine which version number we are working with
Write-Host "What is the release major version number? " -NoNewline
$ReleaseMajorVersion = $Host.UI.ReadLine()

Write-Host "What is the release minor version number? " -NoNewline
$ReleaseMinorVersion = $Host.UI.ReadLine()

Write-Host "Please enter the release tag for v$ReleaseMajorVersion.$ReleaseMinorVersion or leave blank if there is none: " -NoNewline
$ReleaseTag = $Host.UI.ReadLine()

# Determine the full path to the release directory we are working with
$FullReleasesPath = "$ReleasesPath\v$ReleaseMajorVersion\m$ReleaseMinorVersion\$ReleaseMajorVersion.$ReleaseMinorVersion"

# Add the release tag if one exists
if ($ReleaseTag -ne "") {
    $FullReleasesPath += "-$ReleaseTag"
}

# Set the folder for the PyInstaller generated content
$PyInstallerPath = "$FullReleasesPath\py-tool"

# Before proceeding, confirm the path exists and if not, try to create it
if (-Not (Test-Path $FullReleasesPath)) {
    Write-Host "`nThe path $FullReleasesPath doesn't exist."

    # Loop until user answers prompt
    $LoopTrue = $True
    do {
        # Confirm if user wants to create the release directory
        Write-Host "Do you want to create this directory (Y/N)? " -NoNewLine
        $UserPrompt = $Host.UI.ReadLine()

        if (($UserPrompt -eq "Y") -or ($UserPrompt -eq "y")) {
            # Tell loop to quit
            $LoopTrue = $False
        }
        elseif (($UserPrompt -eq "N") -or ($UserPrompt -eq "n")) {
            # Inform user of quitting script
            Write-Host "`nQuitting script..."
            Exit
        }
        else {
            Write-Host "Please make a valid choice!`n"
        }
    } while ($LoopTrue -eq $True)

    # Since loop ended, user chose to create the release directory
    New-Item $FullReleasesPath -ItemType Directory

    # Create the PyInstaller folder
    New-Item $PyInstallerPath -ItemType Directory
}

Set-Location $PyInstallerPath

# Check to see if there's anything already in the PyInstaller folder and if so, delete it
if ((Get-ChildItem $PyInstallerPath).Length -gt 0) {
    Write-Host "`nFound items in the py-tools folder. Deleting all items..."
    Remove-Item -Recurse -Path $PyInstallerPath
    Write-Host "The folder is now empty."
}

# Copy over the files and folder necessary to generate the Python executable
Copy-Item -Path $CSPath -Destination $PyInstallerPath
Copy-Item -Path $DependenciesPath -Destination $PyInstallerPath
Copy-Item -Path $DependenciesPath\*.py -Destination $PyInstallerPath\dependencies

# Change the working directory back to the project root
Set-Location $ProjectRootPath