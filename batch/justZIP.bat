rem #########################################################################################################################
rem 
rem    This script backup all the data from host server and store them in a separate folder.
rem 
rem    This script must be scheduled in host as a scheduled task.
rem
rem    All backups and transfer transactions are logged. 
rem 
rem    7zip must be installed on system and configured on system path.
rem    
rem #########################################################################################################################

rem 											Date and time tokens
rem #########################################################################################################################
rem --------- date and time for English regions, uncomment this if host regional configuration it's English  ----------
rem set y=%date:~10,4%
rem set m=%date:~4,2%
rem set d=%date:~7,2%
rem --------- date and time for Spanish regions, uncomment this if host regional configuration it's Spanish ----------
set y=%date:~6,4%
set m=%date:~3,2%
set d=%date:~0,2%
set hr=%time:~0,2%
if "%hr:~0,1%" equ "0" set hr=0%hr~1,1%
set min=%time:~3,2%
set tstmp=%y%-%m%-%d%_%hr%-%min%
rem #########################################################################################################################

rem the host server ip
set host=192.168.1.206

rem folders where the files gonna be taken to be copied
rem these folders needs to be shared resources in server 
set srcData=\\%host%\Data

rem folders where the files gonna be copied
rem these folders needs to be shared resources in server 
set dstData=\\%host%\Permanent\Data

rem file type expected in source folder
set fType=*.7z
rem log file to write the jobs
set log=\\%host%\Somelogs.txt

rem first we need to compress the test files
echo. >> %log%
echo. ··········································· Start compressing files [%date%] [%time%] ··········································· >> %log%
echo. >> %log%

set zipPathData=%srcData%\%tstmp%_Data.7z
%7z% a -t7z "%zipPathData%" "%srcData%\*.*" -sdel -bb >> %log%

echo. >> %log%
echo. ··········································· Ends compressing files [%date%] [%time%] ··········································· >> %log%
echo. >> %log%
