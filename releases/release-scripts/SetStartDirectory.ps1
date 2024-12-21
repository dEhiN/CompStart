# This function was created using GitHub Copilot but is taken from the following source: cs_helper.py

function Set-StartDirectory {
    <#
    .SYNOPSIS
    Small helper function to set the starting directory

    .DESCRIPTION
    This function will get the path for the current working directory and check to see if the folder CompStart is already on it. It will check for five scenarios:

    1. There is no CompStart folder at all
    2. There is one CompStart folder at the end of the current working directory path
    3. There is one CompStart folder but not at the end of the current working directory path
    4. There is more than one CompStart folder but the last one is at the end of the current working directory path
    5. There is more than one CompStart folder and the last one is not at the end of the current working directory path

    .OUTPUTS
    [bool] Value specifying if a CompStart folder was found on the current working directory path. Essentially scenarios 2-5 above will return True while scenario 1 will return False. It will be assumed that if this function returns true, then the function Get-Location has been set so it will return a path to the CompStart folder that all the relevant files and folders exist in.
    #>

    # Initialize function variables
    $retValue = $false
    $startDir = "CompStart"
    $pathDirsList = (Get-Location).Path -split [System.IO.Path]::DirectorySeparatorChar
    $adjustedLenDirsList = $pathDirsList.Length - 1

    # Get the total of how many CompStart folders are on the cwd path
    $totalStartDirs = ($pathDirsList | Where-Object { $_ -eq $startDir }).Count

    # Check for each case
    if ($totalStartDirs -eq 0) {
        # Scenario 1
        $retValue = $false
    }
    else {
        if ($totalStartDirs -eq 1) {
            # Scenarios 2 or 3

            # Get the index of the CompStart folder in the list
            $idxStartDir = [Array]::IndexOf($pathDirsList, $startDir)
        }
        else {
            # Scenario 4 or 5

            # Loop through to get to the last occurrence of the CompStart folder in the list
            $numStartDirs = 0
            $idxStartDir = -1

            foreach ($currDir in $pathDirsList) {
                $idxStartDir += 1

                if ($currDir -eq $startDir) {
                    $numStartDirs += 1
                }

                if ($numStartDirs -eq $totalStartDirs) {
                    break
                }
            }
        }

        # Check if the index is at the end of the list or in the middle
        if ($idxStartDir -lt $adjustedLenDirsList) {
            # Scenario 3 or 5

            # Get the difference in folder levels between the last folder and the CompStart folder
            $numDirsDiff = $adjustedLenDirsList - $idxStartDir

            # Loop through and move the current working directory one folder level up
            while ($numDirsDiff -gt 0) {
                Set-Location ..
                $numDirsDiff -= 1
            }
        }

        $retValue = $true
    }

    return $retValue
}