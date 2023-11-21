rem Author: rubbishBear
rem Purpose: Agent, Splunk UF, Sysmon INSTALL batch script

@echo off

rem Change the current directory to the location of the script file itself
pushd "%~dp0"

REM Check if running with administrator privileges
NET SESSION >nul 2>&1
if %errorlevel% neq 0 (
    echo This script requires administrator privileges. Please run as an administrator.
    pause
    exit /b
)

setlocal
rem Grab OSArch and set to %ARCH%
for /f "tokens=2 delims==" %%A in ('wmic os get osarchitecture /value') do set "ARCH=%%A"

set SPLUNK_HOME="C:\Program Files\SplunkUniversalForwarder\bin"

rem Set 64/32-bit install functions
:x64_install
start /wait Sysmon64.exe -u force
start /wait cmd.exe /c '%SPLUNK_HOME%\splunk.exe stop'
start /wait msiexec.exe /x %~dp0\SPLUNK\splunkforwarder-9.0.4-de405f4a7979-x64-release.msi /passive
start %WINDIR%\CarbonBlack\uninst.exe /S
popd
exit /b

:x86_install
start /wait Sysmon.exe -u force
start /wait cmd.exe /c '%SPLUNK_HOME%\splunk.exe stop'
start /wait msiexec.exe /x %~dp0\SPLUNK\splunkforwarder-9.0.4-de405f4a7979-x86-release.msi /passive
start %WINDIR%\CarbonBlack\uninst.exe /S
popd
exit /b

if "%ARCH%"=="64-bit" (
    call :x64_install
) else (
    call :x86_install
)