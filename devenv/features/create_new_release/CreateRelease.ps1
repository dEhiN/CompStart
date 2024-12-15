# PowerShell script to create the directory structure for a new release

# Function to create a folder for the major version of a release
function Add-MajorVersion {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0)]
        [string]$MajorVersion,

        [Parameter(Mandatory, Position = 1)]
        [string]$MajorPath
    )
    Write-Host "`Creating directory for release major version $MajorVersion..."
    Write-Host "...at $MajorPath"
    Start-Sleep -Seconds 1
    New-Item $MajorPath -ItemType Directory > $null
}

# Function to create a folder for the minor version of a release
function Add-MinorVersion {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0)]
        [string]$MinorVersion,

        [Parameter(Mandatory, Position = 1)]
        [string]$MinorPath
    )
    Write-Host "`nCreating directory for release minor version $MinorVersion..."
    Write-Host "...at $MinorPath"
    Start-Sleep -Seconds 1
    New-Item $MinorPath -ItemType Directory > $null
}

# Function to create a folder for a release
function Add-ReleaseVersion {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0)]
        [string]$ReleaseVersion,

        [Parameter(Mandatory, Position = 1)]
        [string]$ReleasePath
    )
    Write-Host "`nCreating directory for release $ReleaseVersion..."
    Write-Host "...at $ReleasePath"
    Start-Sleep -Seconds 1
    New-Item $ReleasePath -ItemType Directory > $null
}

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

Write-Host "`What is the release tag for v$ReleaseMajorVersion.$ReleaseMinorVersion (or leave blank if there is none)? " -NoNewline
$ReleaseTag = $Host.UI.ReadLine()

# Create the full release version for later
$ReleaseFullVersion = "$ReleaseMajorVersion.$ReleaseMinorVersion"

# Add the release tag if one exists
if ($ReleaseTag -ne "") {
    $ReleaseFullVersion += "-$ReleaseTag"
}

# Store the release subfolder paths
$ReleaseMajorPath = "$ReleaseVersionsPath\v$ReleaseMajorVersion"
$ReleaseMinorPath = "$ReleaseMajorPath\m$ReleaseMinorVersion"
$ReleaseFullPath = "$ReleaseMinorPath\$ReleaseFullVersion"

# Before proceeding, check if the paths exist
if (-Not (Test-Path $ReleaseMajorPath)) {
    $ExistsMajorPath = $false
}

if (-Not (Test-Path $ReleaseMinorPath)) {
    $ExistsMinorPath = $false
}

if (-Not (Test-Path $ReleaseFullPath)) {
    $ExistsFullPath = $false
}

# Create a boolean tuple to know which folders need to be created
$ReleasePathTuple = [System.Tuple]::Create($ExistsMajorPath, $ExistsMinorPath, $ExistsFullPath)



# Write-Host "`nThe path $ReleaseFullPath doesn't exist."

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