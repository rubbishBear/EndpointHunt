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

set splunk_dep_svr=X.X.X.X:8089

rem Set 64/32-bit install functions
:x64_install
start /wait %~dp0\SYSMON\Sysmon64.exe -i %~dp0\SYSMON\sysmonconfig.xml -accepteula
start /wait msiexec.exe /qn /i %~dp0\SPLUNK\SplunkForwarder64.msi AGREETOLICENSE="yes" DEPLOYMENT_SERVER=%splunk_dep_svr%
start /wait msiexec.exe /qn /i %~dp0\CB\cbsetup.msi CONFIG_FILE="%~dp0\CB\sensorsettings.ini"
popd
exit /b

:x86_install
start /wait %~dp0\SYSMON\Sysmon.exe -i %~dp0\SYSMON\sysmonconfig.xml -accepteula
start /wait msiexec.exe /qn /i %~dp0\SPLUNK\SplunkForwarder32.msi AGREETOLICENSE="yes" DEPLOYMENT_SERVER=%splunk_dep_svr%
start /wait msiexec.exe /qn /i %~dp0\CB\cbsetup.msi CONFIG_FILE="%~dp0\CB\sensorsettings.ini"
popd
exit /b

if "%ARCH%"=="64-bit" (
    call :x64_install
) else (
    call :x86_install
)