<#
.DESCRIPTION
    Use this script to check if a Windows KB update is installed or not.
.NOTES
    Author: @jedvico
#>

# Pull the system info and search for security update
$update = systeminfo.exe | findstr KB4499175

# Inform the installation status
if($update) 
{
    # Put any action needed here if the KB is present
    # like write a network shared file with computer hostname
    Write-Host "Founded!"
}
else
{
    # In case not found, do your stuff here
    # like access a network location where the KB is stored
    # and proceed to installation
    Write-Host "No luck mate, need to installit"
}