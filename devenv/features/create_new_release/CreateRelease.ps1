# PowerShell script to create the directory structure for a new release

# Get the location of the release folder root
$ProjectRootPath = Get-Location

# Check to make sure we are in the project root
if (-Not (Select-String -InputObject $ProjectRootPath -Pattern "CompStart" -CaseSensitive)) {
    # Inform user project root can't be found and the script is ending
    Write-Host "Unable to find project root. Quitting script..."
    Exit
}

# Initialize the variables to be used in the script
$ReleasesFolder = "releases"
$ReleaseVersionsFolder = "release-versions"
$ReleasesVersionsPath = "$ProjectRootPath\$ReleasesFolder\$ReleaseVersionsFolder"

# Determine which release version to create
Write-Host "What is the release major version number? " -NoNewline
$ReleaseMajorVersion = $Host.UI.ReadLine()

Write-Host "What is the release minor version number? " -NoNewline
$ReleaseMinorVersion = $Host.UI.ReadLine()

Write-Host "`nWhat is the release tag for v$ReleaseMajorVersion.$ReleaseMinorVersion (or leave blank if there is none)? " -NoNewline
$ReleaseTag = $Host.UI.ReadLine()

# Determine the full path to the release directory we are working with
$FullReleasesPath = "$ReleasesVersionsPath\v$ReleaseMajorVersion\m$ReleaseMinorVersion\$ReleaseMajorVersion.$ReleaseMinorVersion"

# Add the release tag if one exists
if ($ReleaseTag -ne "") {
    $FullReleasesPath += "-$ReleaseTag"
}

# Before proceeding, confirm the path exists and if not, try to create it
if (-Not (Test-Path $FullReleasesPath)) {
    Write-Host "`nThe path $FullReleasesPath doesn't exist."

    # Loop until user answers prompt
    $LoopTrue = $True
    do {
        # Confirm if user wants to create the release directory
        Write-Host "Do you want to create this directory (Y/N)? " -NoNewLine
        $UserPrompt = $Host.UI.ReadLine()

        if ($UserPrompt.ToUpper() -eq "Y") {
            # Tell loop to quit
            $LoopTrue = $False
        }
        elseif ($UserPrompt.ToUpper() -eq "N") {
            # Inform user of quitting script
            Write-Host "`nQuitting script..."
            Exit
        }
        else {
            Write-Host "Please make a valid choice!`n"
        }
    } while ($LoopTrue -eq $True)

    # Since loop ended, user chose to create the release directory
    Write-Host "`nCreating directory $FullReleasesPath..."
    Start-Sleep -Seconds 1
    New-Item $FullReleasesPath -ItemType Directory > $null
}