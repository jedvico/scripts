<#
.DESCRIPTION
    From a domain server with privileges over domain hosts, send
    message to users with a windows pop up.
.NOTES
    Author: @jedvico
#>

# Set the message after the star symbol
$msg = "msg * This is a test message"
# Hostname or LAN IP can be specified to target the message destination
$host = "D-EVILLEGAS"

# Invoke a windows in remote desktop
invoke-wmimethod -path win32_process -name create -argumentlist '$msg' -computername $host
