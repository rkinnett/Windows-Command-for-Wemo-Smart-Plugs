@ECHO OFF
SETLOCAL EnableDelayedExpansion

:: if the parent directory of this script is not in the PATH environment variable, then temporarily add it, in case curl.exe is in this directory.
echo %PATH%| find /C /I "%~dp0" >nul || SET PATH=%PATH%;%~dp0

:: set DEBUG to "debugON" to enable debug messages:
set DEBUG=debugOFF

set "SYNTAX=instruction^(on^|off^|check^|state^|info^|scan^) ipaddress1^(optional^) ipaddress2^(optional^) debug^(optional^)"

set PORT=49153

set INSTRUCTION=
set IP1=
set IP2=


:: Parse command arguments:
for %%a in (%*) do (
  if "%DEBUG%"=="debugON" echo arg: %%a

  :: test if this arg matches a defined instruction name:
  if "%%a"=="debug" (
    echo arg: %%a
    set "DEBUG=debugON"
  ) else (
    echo.%%a|findstr /r "^[Oo]n$ ^[Oo]ff$ ^[Cc]heck$ ^[Ss]tate$ ^[Ii]nfo$ ^[Ss]can$">nul 2>&1
    if not errorlevel 1 (
      set INSTRUCTION=%%a
    ) else (
      :: test if this arg looks like an IP address:
      call :checkIPFormat "%%a" isValidIP?      
      if "%DEBUG%"=="debugON" echo "%%a" is valid IP: "!isValidIP?!"
      if "!isValidIP?!"=="TRUE" (
        if not defined IP1 (
          set IP1=%%a
        ) else if not defined IP2 (
          set IP2=%%a
        ) else (
          echo error: unrecognized third IP address arg "%%a"
          goto done
        )
      ) else (
        echo error: unrecognized arg "%%a"
        goto done
      )
    )
  )
)
if "%DEBUG%"=="debugON" (
  echo done parsing args
  echo instruction: %INSTRUCTION%
  echo ip1: %IP1%
  echo ip2: %IP2%
)




:: Require INSTRUCTION arg:
if not defined INSTRUCTION (
  echo error, missing instruction argument
  echo syntax: %~n0 %SYNTAX%
  goto done
)



:: Require curl command:
curl -V >nul 2>&1 || (
  echo Error, the curl command does not appear to be available on this machine.
  echo If you're using Windows 10, run windows update to make sure your OS is up to date.
  echo Otherwise, you can download the curl tool here:  https://curl.se
  echo.
  echo Your Windows version:
  ver
  call :halt 1
)


:: Route command:
if "%INSTRUCTION%"=="state" call :checkState       & goto done
if "%INSTRUCTION%"=="check" call :checkState %IP1% & goto done
if "%INSTRUCTION%"=="info"  call :getInfo %IP1%    & goto done
if "%INSTRUCTION%"=="on"    call :setState ON      & goto done
if "%INSTRUCTION%"=="off"   call :setState OFF     & goto done
if "%INSTRUCTION%"=="scan"  call :scan             & goto done
echo "shouldn't be here"
goto done


ENDLOCAL



:::::::::::::::  MAIN METHODS:  :::::::::::::::  


:getInfo
SETLOCAL EnableDelayedExpansion
if not "%~1"=="" (
  echo getInfo "%~1"
  call :checkIPFormat "%~1" isValidIP?
  if "!isValidIP?!"=="TRUE" (
    set "checkaddr=%~1"
  ) else (
    echo getInfo error: first arg "%~1" is not valid IP
    goto done
  )
)
call :requireAddress %checkaddr%
echo Getting info from switch at %checkaddr% ...
set curlCmd=curl -silent http://%checkaddr%:%PORT%/setup.xml
if "%DEBUG%"=="debugON" echo curl command:   %curlCmd%
%curlCmd%>> %TEMP%\wemoinfo
for /f "delims=<> tokens=2" %%i in ('findstr /i /c:"<friendlyName" %TEMP%\wemoinfo')   do (echo Name:   %%i)
for /f "delims=<> tokens=2" %%i in ('findstr /i /c:"<modelName" %TEMP%\wemoinfo')      do (echo Model:  %%i)
for /f "delims=<> tokens=2" %%i in ('findstr /i /c:"<SignalStrength" %TEMP%\wemoinfo') do (echo Signal: %%i)
for /f "delims=<> tokens=2" %%i in ('findstr /i /c:"<macAddress" %TEMP%\wemoinfo')     do (echo MAC:    %%i)
for /f "delims=<> tokens=2" %%i in ('findstr /i /c:"<serialNumber" %TEMP%\wemoinfo')   do (echo Serial: %%i)
for /f "delims=<> tokens=2" %%i in ('findstr /i /c:"<BinaryState" %TEMP%\wemoinfo') do (
  if "%DEBUG%"=="debugON" echo return value: %%i
  if "%%i"=="0" (set "switchstate=%%i (OFF)" ) else (^
  if "%%i"=="1" (set "switchstate=%%i (ON)"  ) else (^  
                 set "switchstate=UNKNOWN"   ))
)
echo State:  %switchstate%
@del %TEMP%\wemoinfo
ENDLOCAL
EXIT /B 0



:checkState
SETLOCAL
if not defined IP1 (
  echo checkState: error, no IP address specified
  goto done
)
echo Checking state..  %IP1%
call :requireAddress %IP1%
set curlCmd=curl -A "" -X POST ^
-H "Content-type: text/xml; charset=\"utf-8\"" ^
-H "SOAPACTION: \"urn:Belkin:service:basicevent:1#GetBinaryState\"" ^
-s http://%IP1%:%PORT%/upnp/control/basicevent1 ^
--data "<?xml version=\"1.0\" encoding=\"utf-8\"?> <s:Envelope xmlns:s=\"http://schemas.xmlsoap.org/soap/envelope/\" s:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\"> <s:Body> <u:GetBinaryState xmlns:u=\"urn:Belkin:service:basicevent:1\"/> </s:Body> </s:Envelope>"
if "%DEBUG%"=="debugON" echo curl command:   %curlCmd%
%curlCmd% >> %TEMP%\wemostatus
for /f "delims=<> tokens=2" %%i in ('findstr /i /c:"<BinaryState" %TEMP%\wemostatus') do (
  if "%DEBUG%"=="debugON" echo return value: %%i
  if "%%i"=="0" (set "switchstate=%%i (OFF)" ) else (^
  if "%%i"=="1" (set "switchstate=%%i (ON)"  ) else (^  
                 set "switchstate=UNKNOWN"   ))
)
echo Switch state: %switchstate%
@del %TEMP%\wemostatus
ENDLOCAL
EXIT /B 0



:setState
SETLOCAL
if not defined IP1 (
  echo setState: error, no IP address specified
  goto done
)
if "%~1"=="ON" (
  set toBinaryState=1
) else (
  if "%~1"=="OFF" (
    set toBinaryState=0
  ) else (
    echo Error, unhandled arg value to setState: "%~1"
    call :halt 1
  )
)
call :requireAddress %IP1%
echo Turning switch %~1 ..
set curlCmd=curl -A "" -X POST ^
  -H "Content-type: text/xml; charset=\"utf-8\"" ^
  -H "SOAPACTION: \"urn:Belkin:service:basicevent:1#SetBinaryState\"" ^
  -s http://%IP1%:%PORT%/upnp/control/basicevent1 ^
  -d "<?xml version=\"1.0\" encoding=\"utf-8\"?> <s:Envelope xmlns:s=\"http://schemas.xmlsoap.org/soap/envelope/\" s:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\"> <s:Body> <u:SetBinaryState xmlns:u=\"urn:Belkin:service:basicevent:1\"> <BinaryState> %toBinaryState% </BinaryState> </u:SetBinaryState> </s:Body> </s:Envelope>"
if "%DEBUG%"=="debugON" echo curl command:   %curlCmd%
%curlCmd% >NUL
call :checkState
ENDLOCAL
EXIT /B 0



:scan
SETLOCAL EnableDelayedExpansion
set myaddr=
set counter=0
set ipmask=

if defined IP1 (
  for /f "tokens=1,2,3,4 delims=." %%a IN ("%IP1%") DO (
    set "ipmask=%%a.%%b.%%c."
    set "lastoctetStart=%%d"
  )
) else (
  if "%DEBUG%"=="debugON" echo Getting your IP address to determine scan range
  call :getMyAddress myaddr
  if "%DEBUG%"=="debugON" echo your IP: "!myaddr!"
  call :checkIPFormat "!myaddr!" isValidIP?
  if "%DEBUG%"=="debugON" echo your ip address: "!myaddr!" is valid: "!isValidIP?!"
  if "!isValidIP?!"=="TRUE" (
    for /f "tokens=1,2,3,4 delims=." %%a IN ("!myaddr!") DO (
      set "ipmask=%%a.%%b.%%c."
      set lastoctetStart=2
    )
  ) else (
    echo.
    echo Error, unable to set IP range automatically.
    echo Try setting start and end addresses explicitly:
    echo Ex:  %~n0 scan 123.4.5.100 123.4.5.120
    call :halt 1
  )
)

if defined IP2 (
  for /f "tokens=1,2,3,4 delims=." %%a IN ("%IP2%") DO (
    set "lastoctetEnd=%%d"
  )
) else (
    set lastoctetEnd=254
)
set "scanFirstAddress=!ipmask!!lastoctetStart!"
set "scanLastAddress=!ipmask!!lastoctetEnd!"

:: Make sure start and end addresses are valid:
call :checkIPFormat !scanFirstAddress! isValidIP?
if "!isValidIP?!"=="FALSE" (echo Error setting start address; call :halt 1)
call :checkIPFormat !scanLastAddress! isValidIP?
if "!isValidIP?!"=="FALSE" (echo Error setting end address; call :halt 1)

:: Scan:
echo Scanning from !scanFirstAddress! to !scanLastAddress!
for /L %%S in (!lastoctetStart!, 1, !lastoctetEnd!) do (
  set suffix=%%S
  set "checkaddr=!ipmask!!suffix!"
  call :probeAddress !checkaddr! available?
  if "!available?!"=="TRUE" (
    echo.
    echo !checkaddr! is open
    call :getInfo !checkaddr!
    echo.
  ) else (
    rem echo !checkaddr! is not open
    echo | set /p dot=.
  )
)
echo done scanning
ENDLOCAL
EXIT /B 0



:::::::::::::::  HELPER FUNCTIONS:   :::::::::::::::  



:requireAddress
call:probeAddress %1 isOpen?
if "%isOpen?%"=="FALSE" (
  echo error, no response at %1:%PORT%
  call :halt 1
)
EXIT /B 0


:probeAddress
set "url=%~1:%PORT%"
set found?=
if "%DEBUG%"=="debugON" echo Probing %url%
set curlCmd=curl --max-time 0.3 -s %url%
if "%DEBUG%"=="debugON" echo curl command:   %curlCmd%
%curlCmd%| find /i "404" >NUL
if not errorlevel 1 (
  set "found?=TRUE"
) else (
  set "found?=FALSE"
)
ENDLOCAL & set "%~2=%found?%"
EXIT /B 0


:getMyAddress
SETLOCAL
for /f "tokens=1-2 delims=:" %%a in ('ipconfig^|find "IPv4"') do set ip==%%b
set myip=%ip:~1%
set myip=%myip: =%
if "%DEBUG%"=="debugON" echo (getMyAddress) ip: "%myip%"
ENDLOCAL & set "%~1=%myip%"
if "%DEBUG%"=="debugON" echo (getMyAddress) ip: "%~1"
EXIT /B 0


:checkIPFormat
SETLOCAL
set valid=
if "%DEBUG%"=="debugON" echo checking ip format "%~1"
echo.%~1|findstr /r "^[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*$">nul 2>&1
if not errorlevel 1 (
  if "%DEBUG%"=="debugON" echo ip address "%~1" is valid
  set "valid?=TRUE"
) else (
  if "%DEBUG%"=="debugON" echo ip address "%~1" is invalid
  set "valid?=FALSE"
)
ENDLOCAL & set "%~2=%valid?%"
EXIT /B 0


:halt
call :__SetErrorLevel %1
call :__ErrorExit 2> nul
goto :done


:__ErrorExit
rem Creates a syntax error, stops immediately
() 
goto :done


:__SetErrorLevel
exit /b %time:~-2%
goto :done



:done
