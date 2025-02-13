# Main PowerShell script for CompStart

function Start-StartupItem {
    <#
        .SYNOPSIS
        Starts a specified startup item.

        .DESCRIPTION
        The `Start-StartupItem` function starts a specified startup item by launching a program at the given path with optional arguments.

        .PARAMETER StartItemNumber
        The number identifying the startup item.

        .PARAMETER ProgramPath
        The path to the program to be started.

        .PARAMETER ArgumentsList
        Optional arguments to be passed to the program.

        .EXAMPLE
        Start-StartupItem -StartItemNumber 1 -ProgramPath "C:\Program Files\Example\example.exe"
        Starts the program located at "C:\Program Files\Example\example.exe" without any arguments.

        .EXAMPLE
        Start-StartupItem -StartItemNumber 2 -ProgramPath "C:\Program Files\Example\example.exe" -ArgumentsList "-arg1 -arg2"
        Starts the program located at "C:\Program Files\Example\example.exe" with the arguments "-arg1 -arg2".

        .NOTES
            Author: David H. Watson (with help from VS Code Copilot)
            GitHub: @dEhiN
            Date: 2024-12-30
    #>
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

function Get-StartupItem {
    <#
        .SYNOPSIS
        Retrieves and starts a specified startup item.

        .DESCRIPTION
        The `Get-StartupItem` function retrieves the properties of a specified startup item and starts it using the `Start-StartupItem` function.

        .PARAMETER StartupItem
        A PSCustomObject representing the startup item, containing properties such as ItemNumber, FilePath, ArgumentCount, and ArgumentList.

        .EXAMPLE
        $startupItem = [PSCustomObject]@{
            ItemNumber = 1
            FilePath = "C:\Program Files\Example\example.exe"
            ArgumentCount = 2
            ArgumentList = @("-arg1", "-arg2")
        }
        Get-StartupItem -StartupItem $startupItem
        Retrieves the startup item properties and starts the program located at "C:\Program Files\Example\example.exe" with the arguments "-arg1 -arg2".

        .NOTES
            Author: David H. Watson (with help from VS Code Copilot)
            GitHub: @dEhiN
            Date: 2024-12-30
    #>
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
            Get-StartupItem $StartupItem
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