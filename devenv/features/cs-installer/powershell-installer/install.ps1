# This will be the installation script used for CompStart

# GLobal variables
$Global:SplitChar = [System.IO.Path]::DirectorySeparatorChar
$Global:SleepTime = 2

function New-CSFolder {
    [CmdletBinding()]
    param (
        [string] $SuppliedPath
    )

    # Initialize function variables
    $CSFolder = "CompStart"
    $CSParentPath = [System.Environment]::GetFolderPath('LocalApplicationData')
    $RetValue = $false

    # Test the passed in parameter and use it if it's a valid path
    if ($SuppliedPath) {
        if (-Not (Test-Path -Path $SuppliedPath)) {
            Write-Host "$SuppliedPath is not a valid file system path...defaulting to $CSParentPath..."
        }
        else {
            $CSParentPath = $SuppliedPath
        }
    }

    # Set the full CompStart folder path
    $CSFullPath = $CSParentPath + $global:SplitChar + $CSFolder

    # Create the folder if need be
    if (-Not (Test-Path $CSFullPath)) {
        Write-Host "`nCreating CompStart folder..."
        Start-Sleep $Global:SleepTime
        New-Item -Path $CSFullPath -ItemType "Directory" > $null
        Write-Host "...folder successfully created at $CSFullPath"
        $RetValue = $true
    }
    else {
        Write-Host "Existing CompStart folder found at $CSFullPath..."
        Start-Sleep $Global:SleepTime
        Write-Host "...skipping this step"
    }

    return $RetValue
}

# Check if the current environment is production or not
$IsProdEnv = $false

if ($IsProdEnv) {
    Write-Host "Production isn't ready yet. Try again later..."
    Exit
}

# Get a list of all the files to "install"
$InstallRelPath = "installer-files"
$InstallFullPath = ($PSScriptRoot + $global:SplitChar + $InstallRelPath)
$FilesList = Get-ChildItem -Recurse $InstallFullPath
foreach ($Item in $FilesList) {
    Write-Host $Item.FullName
}

# Create the CompStart folder if required
New-CSFolder