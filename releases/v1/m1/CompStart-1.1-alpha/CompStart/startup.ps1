# Main PowerShell script for CompStart

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
    #    $ItemName = $StartupItem.Name
    $ItemPath = $StartupItem.FilePath
    #    $ItemDescription = $StartupItem.Description
    #    $ItemIsBrowser = $StartupItem.Browser
    $ItemArgCount = $StartupItem.ArgumentCount
    $ItemArgList = $StartupItem.ArgumentList

    # Process startup arguments
    #$LoopCounter = 0
    $AllArgs = ""

    if ($ItemArgCount -gt 0) {
        foreach ($ItemArg in $ItemArgList) {
            #$LoopCounter += 1
    
            #if ($ItemIsBrowser -and ($LoopCounter -eq $ItemArgCount)) {
            #    $AllArgs += $ItemArg
            #}
            #else {
            #    $AllArgs += [string]$ItemArg
            #}

            $AllArgs += [string]$ItemArg + " "
        }
    }

    Start-StartupItem -StartItemNumber $ItemNumber -ProgramPath $ItemPath -ArgumentsList $AllArgs
}

# Loop until user answers prompt
$LoopTrue = $True

# Show welcome message
Write-Host "Welcome to CompStart!`n"
do {
    # Confirm if user wants to run script
    Write-Host "Would you like to run this script (Y/N)? " -NoNewLine
    $UserPrompt = $Host.UI.ReadLine()

    if (($UserPrompt -eq "Y") -or ($UserPrompt -eq "y")) {

        # Tell loop to quit
        $LoopTrue = $False

        # Set the location of current working directory
        $CurrentLocation = $PSScriptRoot

        # Set the location for production by default
        $DataFileLocation = "\config\"

        Write-Host $DataFileLocation

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
    }
    elseif (($UserPrompt -eq "N") -or ($UserPrompt -eq "n")) {

        # Tell loop to quit
        $LoopTrue = $False

        # Inform user of quitting script
        Write-Host "Quitting script..."

    }
    else {
        Write-Host "Please make a valid choice!`n"
    }
} while ($LoopTrue -eq $True)