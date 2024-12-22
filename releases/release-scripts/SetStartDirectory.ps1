# This function was created using GitHub Copilot but is taken from the following source: the "set_start_dir" function in the "cs_helper.py" module

function Set-StartDir {
    param (
        [string]$DirName
    )

    <#
    .SYNOPSIS
    Small helper function to set the starting directory

    .DESCRIPTION
    This function will get the path for the current working directory (cwd) and check to see if the folder CompStart is already on it. It will check for five scenarios:

    1. There is no CompStart folder at all
    2. There is one CompStart folder at the end of the current working directory path
    3. There is one CompStart folder but not at the end of the current working directory path
    4. There is more than one CompStart folder but the last one is at the end of the current working directory path
    5. There is more than one CompStart folder and the last one is not at the end of the current working directory path

    .PARAMETER DirName
    The name of the start directory to check for

    .OUTPUTS
    [bool] Value specifying if a CompStart folder was found on the current working directory path. Essentially scenarios 2-5 above will return True while scenario 1 will return False. It will be assumed that if this function returns true, then the function Get-Location has been set so it will return a path to the CompStart folder that all the relevant files and folders exist in.
    #>

    # Initialize function variables
    $RetValue = $false
    $StartDir = $DirName
    $PathDirsList = (Get-Location).Path -split [System.IO.Path]::DirectorySeparatorChar
    $AdjustedLenDirsList = $PathDirsList.Length - 1

    # Get the total of how many CompStart folders are on the cwd path
    $TotalStartDirs = ($PathDirsList | Where-Object { $_ -eq $StartDir }).Count

    # Check for each case
    if ($TotalStartDirs -eq 0) {
        # Scenario 1
        $RetValue = $false
    }
    else {
        if ($TotalStartDirs -eq 1) {
            # Scenarios 2 or 3

            # Get the index of the CompStart folder in the list
            $IdxStartDir = $PathDirsList.IndexOf($StartDir)
        }
        else {
            # Scenario 4 or 5

            # Loop through to get to the last occurrence of the CompStart folder in the list
            $NumStartDirs = 0
            $IdxStartDir = -1

            for ($i = 0; $i -lt $PathDirsList.Length; $i++) {
                if ($PathDirsList[$i] -eq $StartDir) {
                    $NumStartDirs++
                }

                if ($NumStartDirs -eq $TotalStartDirs) {
                    $IdxStartDir = $i
                    break
                }
            }
        }

        # Check if the index is at the end of the list or in the middle
        if ($IdxStartDir -lt $AdjustedLenDirsList) {
            # Scenario 3 or 5

            # Get the difference in folder levels between the last folder and the CompStart folder
            $NumDirsDiff = $AdjustedLenDirsList - $IdxStartDir

            # Loop through and move the current working directory one folder level up
            while ($NumDirsDiff -gt 0) {
                Set-Location ..
                $NumDirsDiff--
            }
        }

        $RetValue = $true
    }

    return $RetValue
}