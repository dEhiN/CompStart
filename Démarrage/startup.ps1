# Script to automatically open the apps I want when the computer starts

# Loop until user answers prompt
$LoopTrue = $True
do {
    # Confirm if user wants to run script
    $UserPrompt = Read-Host -Prompt "Would you like to run this script [Y/N]"

    if (($UserPrompt -eq "Y") -or ($UserPrompt -eq "y")) {
        # Tell loop to quit
        $LoopTrue = $False

        # Set up standard working tabs: PassPortal; RMM; Net2Phone; Autotask - Schedule; Autotask - Dashboard
        $DynamixTabs = @(
            "https://ca-clover.passportalmsp.com/login/PP", #Passportal
            "https://concord.rmm.datto.com/dashboard", #RMM - new UI
            "https://net2phone.ca/client-login", #Net2Phone
            "https://lr.autotask.net/Autotask/Views/DispatcherWorkshop/DispatcherWorkshopContainer.aspx", #Autotask - Schedule
            "https://lr.autotask.net/Mvc/Framework/Navigation.mvc/Landing" #Autotask - Dashboard
        )
        $DynamixURLs = [string]$DynamixTabs

        # Set up Dexterra working tabs: Bastion for Jump Box 3; Azure AD; M365 Admin Portal; Dex IT Hub; Dex Laptop List; Microsoft Teams
        $DexterraTabs = @(
            "https://portal.azure.com/#@Dexterra.onmicrosoft.com/resource/subscriptions/f05687c4-951f-433e-b3c0-921f4aa1f857/resourceGroups/PRODJUMP/providers/Microsoft.Compute/virtualMachines/AZU-JUMP03/bastionHost", #Azure - Bastion
            "https://portal.azure.com/#view/Microsoft_AAD_IAM/ActiveDirectoryMenuBlade/~/Overview", #Azure - AAD
            "https://admin.microsoft.com/#/homepage", #M365 Admin Portal
            "https://dexterra.sharepoint.com/sites/InformationTechnology/", #Dexterra IT Hub
            "https://teams.microsoft.com/" #Microsoft Teams
        )
        $DexterraURLS = [string]$DexterraTabs

        # Set up Lindt working tabs
        $LindtTabs = @(
            "https://itservicelindt.service-now.com" #Lindt Service-Now
        )
        $LindtURLS = [string]$LindtTabs
        
        # Open all the programs for startup
        # Outlook
        Start-Process -FilePath "C:\Program Files\Microsoft Office\root\Office16\OUTLOOK.EXE"
        # Chrome - Dynamix
        Start-Process -FilePath "C:\Program Files\Google\Chrome\Application\chrome.exe" -ArgumentList "--profile-directory=Default","--new-window",$DynamixURLs
        # Chrome - Lindt
        Start-Process -FilePath "C:\Program Files\Google\Chrome\Application\chrome.exe" -ArgumentList '--profile-directory="Profile 6"',"--new-window",$LindtURLs
        # Edge - Dexterra
        Start-Process -FilePath "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" -ArgumentList "--profile-directory=Default",$DexterraURLS
    } elseif (($UserPrompt -eq "N") -or ($UserPrompt -eq "n")) {
        # Tell loop to quit
        $LoopTrue = $False

        # Inform user of quitting script
        Write-Host "Quitting script..."
    }
} while ($LoopTrue -eq $True)
