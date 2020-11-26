@ECHO OFF

REM  usage:  wemo IPAddress (on|off|check|state|info)

:: Get input arguments
set IP=%1
set INSTRUCTION=%2

:: This port is standard for Wemo smart plugs:
set PORT=49153


:: Validate specified IP address:
for /f "delims=" %%i in ('echo %IP% ^| findstr /r [0-9]*\.[0-9]*\.[0-9]*\.[0-9][0-9]*') do (set ipvalid=1)
if not "%ipvalid%"=="1" (
echo Error, invalid IP: %IP
goto done
)


:: CHECK IF THERE IS A WEMO DEVICE AT SPECIFIED IP
echo Checking for switch at %IP%:%PORT%
curl -m 10 -s %IP%:%PORT% | find /i "404" >NUL
if errorlevel 1 (
	echo Error, no response at that IP address.
	goto done
)
echo found switch!
echo.


:: Route command:
if "%INSTRUCTION%"=="state" goto checkState
if "%INSTRUCTION%"=="check" goto checkState
if "%INSTRUCTION%"=="info"  goto getInfo
if "%INSTRUCTION%"=="on"    goto turnOn
if "%INSTRUCTION%"=="off"   goto turnOff
goto done



:getInfo
echo Getting info..
curl -silent http://%IP%:%PORT%/setup.xml >> %TEMP%\wemoinfo
for /f "delims=<> tokens=2" %%i in ('findstr /i /c:"<friendlyName" %TEMP%\wemoinfo')   do (echo Name:   %%i)
for /f "delims=<> tokens=2" %%i in ('findstr /i /c:"<modelName" %TEMP%\wemoinfo')      do (echo Model:  %%i)
for /f "delims=<> tokens=2" %%i in ('findstr /i /c:"<BinaryState" %TEMP%\wemoinfo')    do (echo State:  %%i)
for /f "delims=<> tokens=2" %%i in ('findstr /i /c:"<SignalStrength" %TEMP%\wemoinfo') do (echo Signal: %%i)
for /f "delims=<> tokens=2" %%i in ('findstr /i /c:"<macAddress" %TEMP%\wemoinfo')     do (echo MAC:    %%i)
for /f "delims=<> tokens=2" %%i in ('findstr /i /c:"<serialNumber" %TEMP%\wemoinfo')   do (echo Serial: %%i)
@del %TEMP%\wemoinfo
goto done


:checkState
echo Checking state..
curl -A "" -X POST ^
-H "Content-type: text/xml; charset=\"utf-8\"" ^
-H "SOAPACTION: \"urn:Belkin:service:basicevent:1#GetBinaryState\"" ^
-s http://%IP%:%PORT%/upnp/control/basicevent1 ^
--data "<?xml version=\"1.0\" encoding=\"utf-8\"?> <s:Envelope xmlns:s=\"http://schemas.xmlsoap.org/soap/envelope/\" s:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\"> <s:Body> <u:GetBinaryState xmlns:u=\"urn:Belkin:service:basicevent:1\"/> </s:Body> </s:Envelope>" >> %TEMP%\wemostatus

for /f "delims=<> tokens=2" %%i in ('findstr /i /c:"<BinaryState" %TEMP%\wemostatus') do (echo Switch state: %%i)
@del %TEMP%\wemostatus
goto done


:turnOn
echo turning on..
curl -A "" -X POST ^
  -H "Content-type: text/xml; charset=\"utf-8\"" ^
  -H "SOAPACTION: \"urn:Belkin:service:basicevent:1#SetBinaryState\"" ^
  -s http://%IP%:%PORT%/upnp/control/basicevent1 ^
  -d "<?xml version=\"1.0\" encoding=\"utf-8\"?> <s:Envelope xmlns:s=\"http://schemas.xmlsoap.org/soap/envelope/\" s:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\"> <s:Body> <u:SetBinaryState xmlns:u=\"urn:Belkin:service:basicevent:1\"> <BinaryState>1</BinaryState> </u:SetBinaryState> </s:Body> </s:Envelope>"
goto done


:turnOff
echo turning off..
curl -A "" -X POST ^
  -H "Content-type: text/xml; charset=\"utf-8\"" ^
  -H "SOAPACTION: \"urn:Belkin:service:basicevent:1#SetBinaryState\"" ^
  -s http://%IP%:%PORT%/upnp/control/basicevent1 ^
  -d "<?xml version=\"1.0\" encoding=\"utf-8\"?> <s:Envelope xmlns:s=\"http://schemas.xmlsoap.org/soap/envelope/\" s:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\"> <s:Body> <u:SetBinaryState xmlns:u=\"urn:Belkin:service:basicevent:1\"> <BinaryState>0</BinaryState> </u:SetBinaryState> </s:Body> </s:Envelope>"
goto done



:done
echo.