# This will be the installation script used for CompStart

# Convert this BAT code to PowerShell code
<#
:: Toggle between test and prod environments
set "PROD_ENV=false"
:: Relative path of install files folder
set "SCRIPT_RELPATH=install_files\"
:: Relative path of data folder
set "DATA_RELPATH=install_files\data\"
:: Name of startup PowerShell script
set "POWERSHELLSCRIPT_FILENAME=startup.ps1"
#>
$ProdEnv = $false
$ScriptRelPath = "installer_files\"
$DataRelPath = "installer_files\data"
