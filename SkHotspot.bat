@ECHO OFF
setlocal EnableDelayedExpansion

NET FILE 1>NUL 2>NUL
if '%errorlevel%' == '0' ( goto START ) else ( goto getPrivileges ) 

:getPrivileges
if '%1'=='ELEV' ( goto START )

set "batchPath=%~f0"
set "batchArgs=ELEV"

::Add quotes to the batch path, if needed
set "script=%0"
set script=%script:"=%
IF '%0'=='!script!' ( GOTO PathQuotesDone )
    set "batchPath=""%batchPath%"""
:PathQuotesDone

::Add quotes to the arguments, if needed.
:ArgLoop
IF '%1'=='' ( GOTO EndArgLoop ) else ( GOTO AddArg )
    :AddArg
    set "arg=%1"
    set arg=%arg:"=%
    IF '%1'=='!arg!' ( GOTO NoQuotes )
        set "batchArgs=%batchArgs% "%1""
        GOTO QuotesDone
        :NoQuotes
        set "batchArgs=%batchArgs% %1"
    :QuotesDone
    shift
    GOTO ArgLoop
:EndArgLoop

::Create and run the vb script to elevate the batch file
ECHO Set UAC = CreateObject^("Shell.Application"^) > "%temp%\OEgetPrivileges.vbs"
ECHO UAC.ShellExecute "cmd", "/c ""!batchPath! !batchArgs!""", "", "runas", 1 >> "%temp%\OEgetPrivileges.vbs"
"%temp%\OEgetPrivileges.vbs" 
exit /B

:START
::Remove the elevation tag and set the correct working directory
IF '%1'=='ELEV' ( shift /1 )
cd /d %~dp0

::#S
:start
cls
@title Instant Hotspot
color 0b
echo +-------------------------------------------------------------------------+
echo ^|  _____          _              _   _   _       _                   _    ^|
echo ^| ^|_   _^|        ^| ^|            ^| ^| ^| ^| ^| ^|     ^| ^|                 ^| ^|   ^|
echo ^|   ^| ^| _ __  ___^| ^|_ __ _ _ __ ^| ^|_^| ^|_^| ^| ___ ^| ^|_ ___ _ __   ___ ^| ^|_  ^|
echo ^|   ^| ^|^| '_ \/ __^| __/ _` ^| '_ \^| __^|  _  ^|/ _ \^| __/ __^| '_ \ / _ \^| __^| ^|
echo ^|  _^| ^|^| ^| ^| \__ \ ^|^| (_^| ^| ^| ^| ^| ^|_^| ^| ^| ^| (_) ^| ^|_\__ \ ^|_) ^| (_) ^| ^|_  ^|
echo ^|  \___/_^| ^|_^|___/\__\__,_^|_^| ^|_^|\__\_^| ^|_/\___/ \__^|___/ .__/ \___/ \__^| ^|
echo ^|                                                       ^| ^|               ^|
echo ^|                                                       ^|_^|               ^|
echo ^|                           Options Menu                                  ^|
echo ^|                        [1] Create Hotspot                               ^|
echo ^|                        [2] Start Hotspot                                ^|
echo ^|                        [3] Stop Hotspot                                 ^|
echo ^|                        [4] Status and Security Info                     ^|
echo ^|                        [5] List of devices on network                   ^|
echo ^|                        [6] Change password(key)                         ^|
echo +-------------------------------------------------------------------------+
set /p op="Enter an Option: "
if %op%==1 goto setup
if %op%==2 goto start_h
if %op%==3 goto stop_h
if %op%==4 goto status
if %op%==5 goto devices
if %op%==6 goto changekey
echo %op% is not a valid option, Try again!
pause
goto start

:setup
netsh wlan stop hostednetwork >NUL
echo Enter the SSID(Name) for the hotspot
set /p ssid=
echo Enter the password(8 characters minimum) for accessing the hotspot 
set /p pass=
echo ------------------------------------------------------------------------
echo Create a [t]emporary or [p]ermanent hotspot?
echo Temporary hotspot stops after a restart
set /p p_or_t="Enter the marked letter of your prefered option: "
netsh wlan set hostednetwork mode=allow ssid="%ssid%" key="%pass%"
netsh wlan start hostednetwork
if "%p_or_t%"=="p" (
	echo netsh wlan start hostednetwork > "%AppData%\Microsoft\Windows\Start Menu\Programs\Startup\start_hotspot.cmd"
	echo Hotspot set to permanent mode
)
if "%p_or_t%"=="t" (
	del /f /q "%AppData%\Microsoft\Windows\Start Menu\Programs\Startup\start_hotspot.cmd" >NUL
	echo Hotspot set to temporary mode
)
echo ------------------------------------------------------------------------
echo If you want to share Internet you need to open Network and Sharing Center, 
echo Select your working internet connection(which you wish to share), right click on it, go to Properties, 
echo Switch to the tab called Sharing, tick to share the connection and select your created hotspot(Microsoft Hosted Virtual Adapter)
echo ------------------------------------------------------------------------
pause
goto start

:start_h
netsh wlan start hostednetwork
pause
goto start

:stop_h
SET MYFILE="%AppData%\Microsoft\Windows\Start Menu\Programs\Startup\start_hotspot.cmd"
IF EXIST %MYFILE% (
DEL /f /q %MYFILE%
echo Hotspot set to temporary mode
)
netsh wlan stop hostednetwork
pause
goto start

:status
netsh wlan show hostednetwork
netsh wlan show hostednetwork setting=security
pause
goto start

:changekey
echo Enter new password
set /p key=
netsh wlan set hostednetwork key="%key%"
pause
goto start

:devices
@echo off 
set hasClients=0
arp -a | findstr /r "192\.168\.[0-9]*\.[2-9][^0-9] 192\.168\.[0-9]*\.[0-9][0-9][^0-9] 192\.168\.[0-9]*\.[0-1][0-9][0-9]" >test.tmp
arp -a | findstr /r "192\.168\.[0-9]*\.2[0-46-9][0-9] 192\.168\.[0-9]*\.25[0-4]" >>test.tmp
for /F "tokens=1,2,3" %%i in (test.tmp) do call :process %%i %%j %%k
del test.tmp
echo Devices on network
echo ------------------
if %hasClients%==0 echo No device is currently connected to the network
if %hasClients%==1 (
	type result.tmp
	del result.tmp
)
echo ------------------
pause
goto start

:process
set VAR1=%1
ping -a %VAR1% -n 1 | findstr Pinging > loop1.tmp
for /F "tokens=1,2,3" %%i in (loop1.tmp) do call :process2 %%i %%j %%k
del loop1.tmp
goto :EOF

:process2 
SET VAR2=%2
SET VAR3=%3
set hasClients=1
echo %VAR2% %VAR3% >>result.tmp
goto :EOF 

:EOF


