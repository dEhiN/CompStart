# Script to automatically open the apps I want when the computer starts

function Submit-StarupItem {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $StartupItem
    )

    
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

        # Loop through startup data array
        foreach ($StartupItem in $StartupData) {
            # Grab each item's properties
            $Item = [PSCustomObject]@{
                Number = $StartupItem.ItemNumber
                Path = $StartupItem.FilePath
                Browser = $StartupItem.Browser
                ArgCount = $StartupItem.ArgumentCount
                ArgList = $StartupItem.ArgumentList
            }

            Submit-StarupItem $Item
        }

        # To-Do: Create function to parse $Item data - https://www.educba.com/powershell-function-parameters/

        #$DealerFXChromeOneTabs = @()
        #$DealerFXChromeOneURLs = [string]$DealerFXChromeOneTabs
        
        #Start-Process -FilePath "C:\Program Files\Google\Chrome\Application\chrome.exe" -ArgumentList "--profile-directory=Default","--new-window",$DealerFXChromeOneURLs

    } elseif (($UserPrompt -eq "N") -or ($UserPrompt -eq "n")) {

        # Tell loop to quit
        $LoopTrue = $False

        # Inform user of quitting script
        Write-Host "Quitting script..."

    }
} while ($LoopTrue -eq $True)
