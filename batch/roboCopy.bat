rem /MIR        Mirrors a directory tree (equivalent to /e plus /purge).
rem /R:3        Especifies the number of retries on failed copies.
rem /W:10       Especifies the wait time between retries in seconds.
rem /Z          Copy files with restartable flag, in case transfer got interrumpted
rem /NP         Do not display progress 
rem /NDL        Do not log directory names
rem /log+:%log% Write to specific log the activity
rem https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/robocopy

rem Where to source the files
set srcData=C:\Data\src
rem Where to copy the files from source
set dstData=C:\Data\dst
rem The expected files to move
set fType=*.txt
rem Log the activity in this file
set log=%dstData%\log.txt

rem Exec the command with designated parameters
robocopy %srcData% %dstData% /MIR /R:3 /W:10 /Z /NP /NDL /log+:%log%
