<#
.DESCRIPTION
    If in the specific case of windows environment with the need to force
    users to use IE 11 use this script. It will remove all usable files
    for Google Chrome and Mozilla Firefox in specific computers.

    Supposing target computer names start with 'ws' for workstations followed
    by an id like WS1001, WS1002 and so on and you have configured WinRM
    in your domain before. Also, that you have a complete list of hostnames
    from your domain.
.NOTES
    Author: @jedvico
#>

# Create an array for the hostnames
$hostnames = @()

# This CSV file contains all the computers listed in AD
import-csv "\\10.18.10.4\machines.csv" | foreach-object { $hostname += $_.hostnames }

# Loop through all the machines in the CSV file
foreach ($machine in $hostnames) {

    # Test if the machine is online, you need to add quiet param 
    # in order to bypass the error if offline
    $result = test-connection -computerName $machine -count 1 -quiet

    # If machine reply back the icmp requests
    if($result) {

        # Assuming WinRM is already enable by GPO or manually on pc
        invoke-command -computername $machine -scriptblock {

            # List users on this pc and select just workstations
            $users = get-childitem -path c:\users -name

            # Loop through the users inside machine users folder
            foreach ($user in $users) {

                # Perform following tasks over workstations only
                if ($user -match "ws") {

                    # Kill chrome and firefox processes
                    get-process -name Chrome | stop-process         
                    get-process -name Firefox | stop-process

                    # Remove folders from Program Files(X86), add x64 if needed
                    remove-item -path "C:\Program Files (x86)\Google\*" -recurse -force
                    remove-item -path "C:\Program Files (x86)\Mozilla Firefox\*" -recurse -force                   
                   
                    # Remove links from desktop
                    remove-item -path "C:\Users\$user\Desktop\Google*"
                    remove-item -path "C:\Users\$user\Desktop\Chrome*"
                    remove-item -path "C:\Users\$user\Desktop\Mozilla*"
                    remove-item -path "C:\Users\$user\Desktop\Firefox*"

                    # Create shortcut for IE11 on desktop
                    $wshshell = new-object -comobject WScript.Shell
                    $shortcut = $wshshell.createshortcut("C:\Users\$user\Desktop\Internet Explorer 11.lnk")
                    $shortcut.targetpath = "C:\Program Files\Internet Explorer\iexplore.exe"
                    $shortcut.save()

                }
            }
        }
    }
} 