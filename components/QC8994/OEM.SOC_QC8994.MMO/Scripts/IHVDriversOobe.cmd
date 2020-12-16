@echo off

REM Hall
reg add HKLM\SYSTEM\Software\SmartCover /v FrontSensor /t REG_DWORD /d 0
reg add HKLM\SYSTEM\Software\SmartCover /v BackSensor /t REG_DWORD /d 0

reg add HKLM\SYSTEM\HallSensor /v Polarity /t REG_DWORD /d 0
reg add HKLM\SYSTEM\HallSensor /v Disabled /t REG_DWORD /d 0

REM Drivers
call :installRootDevice proxy_driver.inf Root\GripProxy ROOT\GripProxy\0000

goto :eof

REM 
REM Arguments:
REM 
REM 1: Driver Inf filename in driver store's file repository
REM 2: Driver Inf hardware id
REM 3: Root driver hardware id
REM 
:installRootDevice 
for /f "delims=*" %%f in ('dir /b /s \Windows\System32\DriverStore\FileRepository\%1') do \Windows\OEM\devcon.exe install %%f %3
\Windows\OEM\devcon.exe sethwid @%3 := +%2
for /f "delims=*" %%f in ('dir /b /s \Windows\System32\DriverStore\FileRepository\%1') do \Windows\OEM\devcon.exe update %%f %3
goto :eof

REM 
REM Arguments:
REM 
REM 1: Driver Inf filename
REM 2: Driver Inf hardware id
REM 
:updateDeviceIfNoDriver
\Windows\OEM\devcon.exe status "%2" | findstr /E "Driver is running."
if "%ERRORLEVEL%"=="0" goto :eof
\Windows\OEM\devcon.exe update %1 %2
goto :eof
