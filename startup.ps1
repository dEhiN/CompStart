# Script to automatically open the apps I want when the computer starts

# Function to run a specific startup item
# Input: 1. A String representing the full file path + program name with
#        extension of the startup item
#        2. A String representing the full arguments list to pass to
#        this startup item when calling it
#        3. A Int32 representing which startup item number this item is
function Start-StartupItem {
    param (
        [Parameter(Mandatory)]
        [int32]$StartItemNumber,
        
        [Parameter(Mandatory)]
        [string]$ProgramPath,

        [string]$ArgumentsList = $null
    )
    
    if ($ArgumentsList) {
        Start-Process -FilePath $ProgramPath -ArgumentList $ArgumentsList
    }
    else {
        Start-Process -FilePath $ProgramPath
    }
}


# Function to process all the data for a specific startup item
# Input: 1. A PSCustomObject containing all the JSON data for a single
#        startup item
function Get-StarupItem {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [PSCustomObject]$StartupItem
    )

    # Grab each item's properties
    $ItemNumber = $StartupItem.ItemNumber
    $ItemPath = $StartupItem.FilePath
    $ItemArgCount = $StartupItem.ArgumentCount
    $ItemArgList = $StartupItem.ArgumentList

    # Process startup arguments
    $AllArgs = ""

    if ($ItemArgCount -gt 0) {
        foreach ($ItemArg in $ItemArgList) {
            $AllArgs += [string]$ItemArg + " "
        }
    }

    Start-StartupItem -StartItemNumber $ItemNumber -ProgramPath $ItemPath -ArgumentsList $AllArgs
}

# Loop until user answers prompt
$LoopTrue = $True
do {
    # Confirm if user wants to run script
    $UserPrompt = Read-Host -Prompt "Would you like to run this script [Y/N]"

    if (($UserPrompt -eq "Y") -or ($UserPrompt -eq "y")) {

        # Tell loop to quit
        $LoopTrue = $False

        # Name and location of JSON file
        $CurrentLocation = $PSScriptRoot
        # Set the location for production by default
        $DataFileLocation = "\config\"
        # Check if this script is being run in production - as a release
        # or if this script is being run in development
        if (-not (Test-Path ($CurrentLocation + $DataFileLocation))) {
            # Development environment, so change the location
            $DataFileLocation = "\data\json_data\"
        }
        # Set the name of the JSON file
        $DataFileName = "startup_data.json"
        # Concatenate all 3 variables to get the full script path
        $JSONFile = [string]$CurrentLocation + $DataFileLocation + $DataFileName

        # Load JSON data
        $JSONData = Get-Content -Path $JSONFile | ConvertFrom-Json
        $StartupData = $JSONData.Items

        # Loop through startup data array and process each item
        foreach ($StartupItem in $StartupData) {
            Get-StarupItem $StartupItem
        }
    } elseif (($UserPrompt -eq "N") -or ($UserPrompt -eq "n")) {

        # Tell loop to quit
        $LoopTrue = $False

        # Inform user of quitting script
        Write-Host "Quitting script..."

    } else {
        Write-Host "Please make a valid choice!"
    }
} while ($LoopTrue -eq $True)