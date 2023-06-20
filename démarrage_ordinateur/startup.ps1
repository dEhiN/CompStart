# Script to automatically open the apps I want when the computer starts

# Loop until user answers prompt
$LoopTrue = $True
do {
    # Confirm if user wants to run script
    $UserPrompt = Read-Host -Prompt "Would you like to run this script [Y/N]"

    if (($UserPrompt -eq "Y") -or ($UserPrompt -eq "y")) {

        # Tell loop to quit
        $LoopTrue = $False

        # Set up standard working tabs for internal resources: Gmail, GSheet "Client Support Processes", GDoc "Les gabarits pour utiliser avec Halo"
        $DealerFXChromeOneTabs = @(
            "https://mail.google.com/mail/u/0/#inbox",
            "https://docs.google.com/spreadsheets/d/1ZmCBNPA40Ixpcrkl7BmSZdFdrvrxmotk1eIRybobDAM/",
            "https://docs.google.com/document/d/1vrlXzHkL_SDu3-y2MksTYEL-ZAamWQ8hE-ck7Q3Figs/edit"
        )
        $DealerFXChromeOneURLs = [string]$DealerFXChromeOneTabs

        # Set up standard working tabs for external resources: Prod1 One Platform, Kibana Prod1, Prod2 One Platform, Kibana Prod2, AWS Connect - Metrics Report, AWS Agent App
        $DealerFXChromeTwoTabs = @(
            "https://chrysler1.advisordashboard.net/logins/Login.2.aspx",
            "https://vpc-prod1-es01-logs-tt2fnqcrw3ks5r6uangob7sy6u.us-east-1.es.amazonaws.com/_plugin/kibana/app/kibana#/discover?_g=()&_a=(columns:!(_source),index:fa06ab90-d9d6-11e8-a98f-e9ebcc5de641,interval:auto,query:(language:lucene,query:''),sort:!('@timestamp',desc))",
            "https://service.dealer-fx.com/logins/Login.2.aspx",
            "https://vpc-prod2-es-logs-uf3z64zx5gyuk3chonnjhglbpy.us-east-1.es.amazonaws.com/_plugin/kibana/app/discover#/?_g=(filters:!(),refreshInterval:(pause:!t,value:0),time:(from:now-15m,to:now))&_a=(columns:!(_source),filters:!(),index:b0c225e0-ce3e-11eb-82d0-0bde78b21518,interval:auto,query:(language:kuery,query:''),sort:!())",
            "https://dfx1.my.connect.aws/metrics-reports",
            "https://master.d3pfi7mlwkgahz.amplifyapp.com/"
        )
        $DealerFXChromeTwoURLs = [string]$DealerFXChromeTwoTabs

        # Set up working tabs pertaining to tickets: GSheet "New Email - ALL OEM", GSheet "BLoc-notes des billets"
        $DealerFXChromeThreeTabs = @(
            "https://docs.google.com/spreadsheets/d/1165JnOAgr0JkNRu7lIWUD_OmbwsSLWfDvx3Ha8JvSKk/",
            "https://docs.google.com/spreadsheets/d/1q5NXZtm0Ln94gMi8FapfNvtbviVzrtcnS8IBUiH5Qic/"
        )
        $DealerFXChromeThreeURLs = [string]$DealerFXChromeThreeTabs
        
        # Open all the programs for startup
        # Chrome - Dealer-FX standard working tabs for internal resources
        Start-Process -FilePath "C:\Program Files\Google\Chrome\Application\chrome.exe" -ArgumentList "--profile-directory=Default","--new-window",$DealerFXChromeOneURLs
        # Chrome - Dealer-FX standard working tabs for external resources
        Start-Process -FilePath "C:\Program Files\Google\Chrome\Application\chrome.exe" -ArgumentList "--profile-directory=Default","--new-window",$DealerFXChromeTwoURLs
        # Chrome - Dealer-FX working tabs for tickets
        Start-Process -FilePath "C:\Program Files\Google\Chrome\Application\chrome.exe" -ArgumentList "--profile-directory=Default","--new-window",$DealerFXChromeThreeURLs
        # Google Chat Chrome app
        Start-Process -FilePath "C:\Program Files\Google\Chrome\Application\chrome_proxy.exe" -ArgumentList "--profile-directory=Default", "--app-id=mdpkiolbdkhdjpekfbkbmhigcaggjagi"
        # Halo Chrome app
        Start-Process -FilePath "C:\Program Files\Google\Chrome\Application\chrome_proxy.exe" -ArgumentList "--profile-directory=Default","--app-id=ifgfkkbichmgomaifmnecbnpibfepmco"
        # Drive Chrome app
        Start-Process -FilePath "C:\Program Files\Google\Chrome\Application\chrome_proxy.exe"  -ArgumentList "--profile-directory=Default --app-id=aghbiahbpaijignceidepookljebhfak"
        # Zoom
        Start-Process -FilePath "C:\Program Files\Zoom\bin\Zoom.exe"
        # FortiClient VPN
        Start-Process -FilePath "C:\Program Files\Fortinet\FortiClient\FortiClient.exe"

    } elseif (($UserPrompt -eq "N") -or ($UserPrompt -eq "n")) {

        # Tell loop to quit
        $LoopTrue = $False

        # Inform user of quitting script
        Write-Host "Quitting script..."

    }
} while ($LoopTrue -eq $True)
