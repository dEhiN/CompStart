# This will be the installation script used for CompStart

# Check if the current environment is production or not
$IsProdEnv = $false

if ($IsProdEnv) {
    Write-Host "Production isn't ready yet. Try again later..."
    Exit
}

# Get a list of all the files to "install"
$InstallRelPath = "installer-files"
$SplitChar = [System.IO.Path]::DirectorySeparatorChar
$InstallFullPath = ($PSScriptRoot + $SplitChar + $InstallRelPath)
$FilesList = Get-ChildItem -Recurse $InstallFullPath
foreach ($Item in $FilesList) {
    Write-Host $Item.FullName
}