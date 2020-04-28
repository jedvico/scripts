rem Script take files from network location, replace them for the original ones.
rem Could be useful if you need to be sure users got the right files and even more if they likely to be able to modify from network location.
rem Use task scheduler to program this task as you need.

title File Restoration _NameYourRigHere_
set logger=C:\Logs\MyRigLog.log
echo # >> %logger%
echo # >> %logger%
echo # >> %logger%
echo # >> %logger%
echo # This script restore template files for Enigma Rig >> %logger%
echo # >> %logger%
echo # >> %logger%
echo # Starting restoration %date% %time% >> %logger%
echo # >> %logger%
echo # >> %logger%
echo # >> %logger%

rem remove the files from the folder where they are being used. /s to remove entire folder tree and /q for quiet
rd "\\192.168.1.162\Enigma_Production\" /s /q >> %logger%

echo ------------------------------------------------------------------------------------------------------------------------- >> %logger%
echo # >> %logger%
echo # >> %logger%
echo # >> %logger%
echo # Copying files from source... >> %logger%
echo # >> %logger%
echo # >> %logger%
echo ------------------------------------------------------------------------------------------------------------------------- >> %logger%
rem copy all files and folders from source folder to production folder, assume destination is folder and suppress prompts it is there any
xcopy \\192.168.1.162\Enigma_Source\*.* \\192.168.1.162\Enigma_Production\ /e /i /y >> %logger%
echo ------------------------------------------------------------------------------------------------------------------------- >> %logger%
echo # >> %logger%
echo # >> %logger%
echo # >> %logger%
echo # >> %logger%
echo # >> %logger%
echo # Copy finished. %date% %time% >> %logger%
exit
