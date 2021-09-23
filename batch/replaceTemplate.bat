rem #
rem # This script has been developed to replace files from one folder with the ones from a master folder. 
rem # It is designed to be programed as a scheduled task in windows. 
rem #

rem set the log file path
set log=C:\Users\jedvico\log.txt
rem set the master folder that contains the master unmodified templates
rem set mstdir=\\192.168.1.162\SourceFolder\
set mstdir=C:\Users\jedvico\LBP\LB3
rem set the destination where the templates want to be copied
rem set slvdir=\\192.168.1.162\DestinationFolder\
set slvdir=C:\Users\jedvico\LB\LB3
rem remove all the files and directories from the desire directory

echo. >> %log%
echo ----------------------------------------------------------------------------------------------- >> %log%
echo                                ABOUT TO REMOVE FILES FROM FOLDER >> %log%
echo ----------------------------------------------------------------------------------------------- >> %log%
echo. >> %log%
echo [FOLDER = "%slvdir%"] >> %log%
echo [DATE = %date%] >> %log%
echo [TIME = %time%] >> %log%
echo. >> %log%
echo removing... >> %log%
rd "%slvdir%" /s /q >> %log%
rem handle any kind of error
if errorlevel 0 (
	rem success with deletion
	goto COPY
)else if errorlevel 1 (
	rem invalid option
	goto error1
) else if errorlevel 2 (
	rem directory not found
	goto error2
) else if errorlevel 5 (
	rem access denied
	goto error5
) else if errorlevel 32 (
	rem directory in use
	goto error32
) else goto error
echo removing complete >> %log%
echo. >> %log%
echo ----------------------------------------------------------------------------------------------- >> %log%
echo. >> %log%


:COPY
echo. >> %log%
echo ----------------------------------------------------------------------------------------------- >> %log%
echo 							ABOUT TO COPY FILES FROM PERMANENT FOLDER >> %log%
echo ----------------------------------------------------------------------------------------------- >> %log%
echo. >> %log%
echo [SOURCE = "%mstdir%"] >> %log%
echo [DESTINATION = "%mstdir%"] >> %log%
echo [DATE = %date%] >> %log% 
echo [TIME = %time%] >> %log%
echo. >> %log%
echo copying... >> %log%
echo [source="%mstdir%"   destination="%mstdir%"] >> %log%
xcopy %mstdir%\*.* "%slvdir%" /e /i /y >> %log%
echo copying complete >> %log%
echo. >> %log%
echo ----------------------------------------------------------------------------------------------- >> %log%
echo. >> %log%
exit

rem  # # # # # # # # # # # # # # # # # # # # # # ERROR HANDLING # # # # # # # # # # # # # # # # # # # # # # # #

rem general error
:erro
echo. >> %log%
echo ********************************************************************************************** >> %log%
echo. >> %log%
echo 									WARNING: GENERAL ERROR FOUND >> %log%
echo. >> %log%
echo										FOLDERS NOT DELETED >> %log%
echo. >> %log%
echo ********************************************************************************************** >> %log%
echo. >> %log%
exit

rem invalid option
:erro1 
echo. >> %log%
echo ********************************************************************************************** >> %log%
echo. >> %log%
echo 							  WARNING: SPECIFIC ERROR FOUND [INVALID OPTION]  >> %log%
echo. >> %log%
echo										FOLDERS NOT DELETED >> %log%
echo. >> %log%
echo ********************************************************************************************** >> %log%
echo. >> %log%
exit

rem directory not found
:erro2
echo. >> %log%
echo ********************************************************************************************** >> %log%
echo. >> %log%
echo 						WARNING: SPECIFIC ERROR FOUND [DIRECTORY NOT FOUND]  >> %log%
echo. >> %log%
echo										FOLDERS NOT DELETED >> %log%
echo. >> %log%
echo ********************************************************************************************** >> %log%
echo. >> %log%
exit

rem access denied
:erro5
echo. >> %log%
echo ********************************************************************************************** >> %log%
echo. >> %log%
echo       						WARNING: SPECIFIC ERROR FOUND [ACCESS DENIED]  >> %log%
echo. >> %log%
echo										FOLDERS NOT DELETED >> %log%
echo. >> %log%
echo ********************************************************************************************** >> %log%
echo. >> %log%
exit

rem directory in use
:erro32
echo. >> %log%
echo ********************************************************************************************** >> %log%
echo. >> %log%
echo       						WARNING: SPECIFIC ERROR FOUND [ACCESS DENIED]  >> %log%
echo. >> %log%
echo										FOLDERS NOT DELETED >> %log%
echo. >> %log%
echo ********************************************************************************************** >> %log%
echo. >> %log%
exit
