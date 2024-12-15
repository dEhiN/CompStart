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
$ReleaseVersionsPath = "$ProjectRootPath\$ReleasesFolder\$ReleaseVersionsFolder"

# Determine which release version to create
Write-Host "What is the release major version number? " -NoNewline
$ReleaseMajorVersion = $Host.UI.ReadLine()

Write-Host "What is the release minor version number? " -NoNewline
$ReleaseMinorVersion = $Host.UI.ReadLine()

Write-Host "`nWhat is the release tag for v$ReleaseMajorVersion.$ReleaseMinorVersion (or leave blank if there is none)? " -NoNewline
$ReleaseTag = $Host.UI.ReadLine()

# Determine the release subfolders
$ReleaseMajorPath = "$ReleaseVersionsPath\v$ReleaseMajorVersion"
$ReleaseMinorPath = "$ReleaseMajorPath\m$ReleaseMinorVersion"
$ReleaseFullPath = "$ReleaseMinorPath\$ReleaseMajorVersion.$ReleaseMinorVersion"

# Add the release tag if one exists
if ($ReleaseTag -ne "") {
    $ReleaseFullPath += "-$ReleaseTag"
}

# Before proceeding, confirm the paths exist and if not, try to create them
if (-Not (Test-Path $ReleaseMajorPath)) {
    Write-Host "`nThe path $ReleaseMajorPath doesn't exist."
}

if (-Not (Test-Path $ReleaseMinorPath)) {
    Write-Host "`nThe path $ReleaseMinorPath doesn't exist."
}

if (-Not (Test-Path $ReleaseFullPath)) {
    Write-Host "`nThe path $ReleaseFullPath doesn't exist."

# Loop until user answers prompt
#$LoopTrue = $True
#do {
# Confirm if user wants to create the release directory
#    Write-Host "Do you want to create this directory (Y/N)? " -NoNewLine
#    $UserPrompt = $Host.UI.ReadLine()

#    if ($UserPrompt.ToUpper() -eq "Y") {
#        # Tell loop to quit
#        $LoopTrue = $False
#    }
#    elseif ($UserPrompt.ToUpper() -eq "N") {
# Inform user of quitting script
#        Write-Host "`nQuitting script..."
#        Exit
#    }
#    else {
#        Write-Host "Please make a valid choice!`n"
#    }
#} while ($LoopTrue -eq $True)

# Since loop ended, user chose to create the release directory
#Write-Host "`nCreating directory $ReleaseFullPath..."
#Start-Sleep -Seconds 1
#New-Item $ReleaseFullPath -ItemType Directory > $null