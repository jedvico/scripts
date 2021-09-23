<#
.DESCRIPTION
    Empty download folders from all computers on a domain which has a certain name, 
    like WS001, WS002, etc.
    It uses WinRM tools to perform this task trough all computers. Just
    deletes all files in this directory.
    This script must be executed from Active Directory or any computer with
    access to AD cmdlets.
.NOTES
    Author: @jedvico
#>

$computers = get-adcomputer -filter 'name -like "*Operator*"'
$w_winrm = @()
$wo_winrm = @()

foreach ($computer in $computers) 
{
    $hostname = $computer.name
    if(test-wsman $hostname -erroraction silentlycontinue) 
    { 
        $w_winrm += $hostname 
    }
    else 
    { 
        $wo_winrm += $hostname 
    }
}

foreach ($hostname in $wo_winrm) 
{
    invoke-command -computername $hostname -scriptblock 
    { 
        if($env:username -match "") 
        { 
            get-childitem -path "$env:userprofile\downloads" -recurse | remove-item -force 
        } 
    }
}
