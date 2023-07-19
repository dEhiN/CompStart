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
        # TODO
        #Write-Host $ArgumentsList
        Start-Process -FilePath $ProgramPath -ArgumentList $ArgumentsList
    }
    else {
        # TODO
        #Write-Host $ArgumentsList
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
    $ItemIsBrowser = $StartupItem.Browser
    $ItemArgCount = $StartupItem.ArgumentCount
    $ItemArgList = $StartupItem.ArgumentList
    $ItemComments = $StartupItem.Comments

    # Process startup arguments
    $LoopCounter = 0
    $AllArgs = ""

    if ($ItemArgCount -gt 0) {
        foreach ($ItemArg in $ItemArgList) {
            $LoopCounter += 1
    
            if ($ItemIsBrowser -and ($LoopCounter -eq $ItemArgCount)) {
                $AllArgs += $ItemArg
            }
            else {
                $AllArgs += [string]$ItemArg
            }

            $AllArgs += " "
        }
    }

    Start-StartupItem -StartItemNumber $ItemNumber -ProgramPath $ItemPath -ArgumentsList $AllArgs
    
    #$DealerFXChromeOneTabs = @()
    #$DealerFXChromeOneURLs = [string]$DealerFXChromeOneTabs
    
    #Start-Process -FilePath $ItemPath -ArgumentList

    #Start-Process -FilePath "C:\Program Files\Google\Chrome\Application\chrome.exe" -ArgumentList "--profile-directory=Default","--new-window",$DealerFXChromeOneURLs
}

# Loop until user answers prompt
$LoopTrue = $True
do {
    # Confirm if user wants to run script
    #$UserPrompt = Read-Host -Prompt "Would you like to run this script [Y/N]"
    $UserPrompt = "Y"

    if (($UserPrompt -eq "Y") -or ($UserPrompt -eq "y")) {

        # Tell loop to quit
        $LoopTrue = $False

        # Name and location of JSON file
        $CurrentLocation = $PSScriptRoot
        $DataFileLocation = "\data\"
        $DataFileName = "startup_data.json"
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
} while ($LoopTrue -eq $True)
