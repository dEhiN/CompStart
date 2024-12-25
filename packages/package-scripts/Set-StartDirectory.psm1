# This function was created using GitHub Copilot
# It was taken from the function "set_start_dir" function in the Python module "cs_helper.py"
# It has been modified to work in PowerShell and to be more idiomatic to the language
# Finally, this function has been set up as a PowerShell module for easy reuse in other scripts

function Set-StartDirectory {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0)]
        [string]$DirectoryName
    )

    <#
    .SYNOPSIS
    Small helper function to set the starting directory

    .DESCRIPTION
    This function will get the path for the current working directory (cwd) and check to see if the directory passed in as a parameter is already on it. It will check for five scenarios:

    1. There is no folder at all
    2. There is one folder at the end of the current working directory path
    3. There is one folder but not at the end of the current working directory path
    4. There is more than one folder but the last one is at the end of the current working directory path
    5. There is more than one folder and the last one is not at the end of the current working directory path

    .PARAMETER DirectoryName
    The name of the directory to check for

    .OUTPUTS
    [bool] Value specifying if the folder to check for was found on the current working directory path. Essentially scenarios 2-5 above will return True while scenario 1 will return False. It will be assumed that if this function returns true, then the function Set-Location has been used to move the current working directory to the desired location.
    #>

    # Initialize function variables
    $ReturnValue = $false
    $StartDirectory = $DirectoryName
    $SplitChar = "\" + [System.IO.Path]::DirectorySeparatorChar
    $PathDirectoriesList = (Get-Location).Path -split $SplitChar
    $AdjustedLengthPDL = $PathDirectoriesList.Length - 1

    # Get the total number of folders matching the passed in directory name on the current working directory path
    $TotalStartDirectories = ($PathDirectoriesList | Where-Object { $_ -eq $StartDirectory }).Count

    # Check for each case
    if ($TotalStartDirectories -eq 0) {
        # Scenario 1
        $ReturnValue = $false
    }
    else {
        if ($TotalStartDirectories -eq 1) {
            # Scenarios 2 or 3

            # Get the index of the CompStart folder in the list
            $IndexStartDirectory = $PathDirectoriesList.IndexOf($StartDirectory)
        }
        else {
            # Scenario 4 or 5

            # Loop through to get to the last occurrence of the CompStart folder in the list
            $CountStartDirectories = 0
            $IndexStartDirectory = -1

            for ($i = 0; $i -lt $PathDirectoriesList.Length; $i++) {
                if ($PathDirectoriesList[$i] -eq $StartDirectory) {
                    $CountStartDirectories++
                }

                if ($CountStartDirectories -eq $TotalStartDirectories) {
                    $IndexStartDirectory = $i
                    break
                }
            }
        }

        # Check if the index is at the end of the list or in the middle
        if ($IndexStartDirectory -lt $AdjustedLengthPDL) {
            # Scenario 3 or 5

            # Get the difference in folder levels between the last folder and the starting directory
            $CountDirectoriesOffset = $AdjustedLengthPDL - $IndexStartDirectory

            # Loop through and move the current working directory one folder level up
            while ($CountDirectoriesOffset -gt 0) {
                Set-Location ..
                $CountDirectoriesOffset--
            }
        }

        $ReturnValue = $true
    }

    return $ReturnValue
}