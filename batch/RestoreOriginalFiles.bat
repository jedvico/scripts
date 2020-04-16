rem Script take files from network location, replace them for the original ones.
rem Could be useful if you need to be sure users got the right files and even more if they likely to be able to modify from network location.
rem Use task scheduler to program this task as you need.

TITLE File Restoration _NameYourRigHere_
SET Logger=C:\Logs\MyRigLog.log
echo # >> %Logger%
echo # >> %Logger%
echo # >> %Logger%
echo # >> %Logger%
echo # This script restore template files for Enigma Rig >> %Logger%
echo # >> %Logger%
echo # >> %Logger%
echo # Starting restoration %date% %time% >> %Logger%
echo # >> %Logger%
echo # >> %Logger%
echo # >> %Logger%

rem remove the files from the folder where they are being used. /s to remove entire folder tree and /q for quiet
rd "\\192.168.1.162\Enigma_Production\" /s /q >> %Logger%

echo ------------------------------------------------------------------------------------------------------------------------- >> %Logger%
echo # >> %Logger%
echo # >> %Logger%
echo # >> %Logger%
echo # Copying files from source... >> %Logger%
echo # >> %Logger%
echo # >> %Logger%
echo ------------------------------------------------------------------------------------------------------------------------- >> %Logger%
rem copy all files and folders from source folder to production folder, assume destination is folder and suppress prompts it is there any
xcopy \\192.168.1.162\Enigma_Source\*.* \\192.168.1.162\Enigma_Production\ /e /i /y >> %Logger%
echo ------------------------------------------------------------------------------------------------------------------------- >> %Logger%
echo # >> %Logger%
echo # >> %Logger%
echo # >> %Logger%
echo # >> %Logger%
echo # >> %Logger%
echo # Copy finished. %date% %time% >> %Logger%
exit
