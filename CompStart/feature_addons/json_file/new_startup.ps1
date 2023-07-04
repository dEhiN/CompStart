# Script to automatically open the apps I want when the computer starts

# Loop until user answers prompt
$LoopTrue = $True
do {
    # Confirm if user wants to run script
    #$UserPrompt = Read-Host -Prompt "Would you like to run this script [Y/N]"
    $UserPrompt = "Y"

    if (($UserPrompt -eq "Y") -or ($UserPrompt -eq "y")) {

        # Tell loop to quit
        $LoopTrue = $False

        # Name of JSON file with all startup data
        $DataFileName = "startup_data.json"
        $CurrentLocation = $PSScriptRoot
        $DataFileLocation = "\data\"
        $JSONFile = [string]$CurrentLocation + $DataFileLocation + $DataFileName

        Write-Host $JSONFile
        Write-Host $PSScriptRoot

        # Load JSON data
        #$StartupData = Get-Content -Path $JSONFile -Raw | ConvertFrom-Json

        #Write-Host $StartupData


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
