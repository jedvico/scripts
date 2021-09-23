<#
.DESCRIPTION
    Use this script to validate a list of hosts and whether they have
    or habe not WinRM enabled and reachable. A list of 3 files will be 
    created and will contain the result (computers online, with WinRM 
    and without WinRM)
.NOTES
    Author: @jedvico
#>

# Array objet for storing resulting hostnames
$hostNames = @()

# Variable that holds a list of hosts to scan
$allWS = "C:\hostnames.csv"

# Import the hostnames from the csv file into the object
import-csv $allWS | foreach-object {$hostNames += $_.hostnames}

# Set the lists of output files with data, echoable for online machines,
# withWRM, for onlines machines and with WinRM enabled. Etc...
$echoable = "C:\echoable.txt" 
$withWRM = "C:\withWRM.txt"
$withOutWRM = "C:\withOutWRM.txt"

# Put all the output files in array just to check if files exists
# and if it not, create them.
$files = @($echoable, $withWRM, $withOutWRM)

# Handle the creation and wipe of data/files. Remove the files
# if is there any with the same names.
foreach ($file in $files) 
{
    if(test-path $file) 
    {
        remove-item -path $file -force
    } 
    new-item $file
}

# Loop through all the hosts in the array object
foreach ($machine in $hostNames) 
{
    # Echo request to each machine
    $R = test-connection -computerName $machine -count 1 -delay 1 -erroraction silentlycontinue
    
    # If the echo request returns null value then machine is offline, first iterate
    # in the ones responding back.
    if ($null -ne $R) 
    {
        # Add the machine to list once it has respond to echo request
        add-content -path $echoable -value $machine -verbose

        # Have WinRM requested to computer object to check its availability
        $R = test-wsman -computername $machine -erroraction silentlycontinue
        
        # If WSMan reply back is different from null then it has WinRm and now we can start
        # to work remotely in host being iterated
        if ($null -ne $R) 
        {
            # Add the machine to list once it has respond to request
            add-content -path $withWRM -value $machine -verbose
        } 
        else 
        {
            # This means that no WinRm was found in machine, which could be caused due to firewall or lack of winrm quickonfig 
            add-content -path $withOutWRM -value $machine -verbose
        }
    }
}
