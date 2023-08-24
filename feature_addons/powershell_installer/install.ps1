# This will be the installation script used for CompStart

$IsProdEnv = $false
$InstallRelPath = "installer_files\"

if ($IsProdEnv) {
    Write-Host "Production isn't ready yet. Try again later..."
    exit
}

$InstallFullPath = ($PSScriptRoot + "\" + $InstallRelPath)

$FilesList = Get-ChildItem -Recurse $InstallFullPath

foreach ($Item in $FilesList) {
    Write-Host $Item.FullName
}