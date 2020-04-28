<#
.DESCRIPTION
    If need to copy some files from your computer to a network locations
    just when you get connected to a specific SSID, use this script and 
    specify your source and destination, and the network name as well. You
    can use this script with a scheduled task in your computer.
.NOTES
    Author: @jedvico
#>

# Your local files directory, using a wildcard to copy all inside of it
$srcDir = "H:\EnigmaDocs\*"

# Network location where the files are going to be copied
$dstDir = "\\10.45.1.18\EnigmaBkp\Docs"

# The network name to which you are connected to
$netName = (get-netconnectionprofile).name

if( $netName = "IT Group Net")
{
    # I needed to copy just spreadsheets from source to destination, and 
    # recurse and force parameter are being used in order to iterate inside
    # all source sub-folders and force rewrite files in destination if 
    # already exists there
    copy-item -path $srcDir -filter "*.xlsx" -destination $dstDir -recurse -force
}