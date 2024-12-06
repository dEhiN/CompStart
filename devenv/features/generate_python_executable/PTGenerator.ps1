# PowerShell script to automate the generation of the Python command line tool CompStart.py to an executable using the Python module PyInstaller. This script is meant to be used for releases and will assume the release folder has been created. As a result, only a "py-tool" folder will be created where everything will be copied and worked on.

# Get the location of the release folder root
Get-Location