@echo off
setlocal EnableExtensions

rem Yandex Browser: disable all documented browser data import policies.
rem Run this script as Administrator (or as SYSTEM).

set "POLICY_KEY=HKLM\SOFTWARE\Policies\YandexBrowser"

rem Use 64-bit reg.exe on 64-bit Windows even if launched from a 32-bit management agent.
if exist "%SystemRoot%\Sysnative\reg.exe" (
    set "REGEXE=%SystemRoot%\Sysnative\reg.exe"
) else (
    set "REGEXE=%SystemRoot%\System32\reg.exe"
)

rem Verify that we can write machine policies.
"%REGEXE%" add "%POLICY_KEY%" /f >nul 2>&1
if errorlevel 1 goto :admin_error

rem Boolean Yandex Browser policies are stored as REG_SZ.
rem 0 = Disabled.
"%REGEXE%" add "%POLICY_KEY%" /v "ImportOnFirstRun"     /t REG_SZ /d "0" /f || goto :write_error
"%REGEXE%" add "%POLICY_KEY%" /v "ImportBookmarks"      /t REG_SZ /d "0" /f || goto :write_error
"%REGEXE%" add "%POLICY_KEY%" /v "ImportHistory"        /t REG_SZ /d "0" /f || goto :write_error
"%REGEXE%" add "%POLICY_KEY%" /v "ImportLastSession"    /t REG_SZ /d "0" /f || goto :write_error
"%REGEXE%" add "%POLICY_KEY%" /v "ImportSearchEngine"   /t REG_SZ /d "0" /f || goto :write_error
"%REGEXE%" add "%POLICY_KEY%" /v "ImportExtensions"     /t REG_SZ /d "0" /f || goto :write_error
"%REGEXE%" add "%POLICY_KEY%" /v "ImportOther"          /t REG_SZ /d "0" /f || goto :write_error
"%REGEXE%" add "%POLICY_KEY%" /v "ImportSavedPasswords" /t REG_SZ /d "0" /f || goto :write_error
"%REGEXE%" add "%POLICY_KEY%" /v "ImportCookies"        /t REG_SZ /d "0" /f || goto :write_error

rem Existing import-source/path policies must be reviewed separately; see README.md.

echo.
echo Registry path:
echo   %POLICY_KEY%
echo.
echo Verification:
"%REGEXE%" query "%POLICY_KEY%" /v "ImportOnFirstRun" || goto :write_error
"%REGEXE%" query "%POLICY_KEY%" /v "ImportBookmarks" || goto :write_error
"%REGEXE%" query "%POLICY_KEY%" /v "ImportHistory" || goto :write_error
"%REGEXE%" query "%POLICY_KEY%" /v "ImportLastSession" || goto :write_error
"%REGEXE%" query "%POLICY_KEY%" /v "ImportSearchEngine" || goto :write_error
"%REGEXE%" query "%POLICY_KEY%" /v "ImportExtensions" || goto :write_error
"%REGEXE%" query "%POLICY_KEY%" /v "ImportOther" || goto :write_error
"%REGEXE%" query "%POLICY_KEY%" /v "ImportSavedPasswords" || goto :write_error
"%REGEXE%" query "%POLICY_KEY%" /v "ImportCookies" || goto :write_error

echo.
echo Yandex Browser import policies were written and read back successfully.
echo In Yandex Browser open browser://policy and click Reload policies.
exit /b 0

:admin_error
echo.
echo ERROR: Cannot write to HKLM.
echo Run this CMD file as Administrator or deploy it as SYSTEM.
exit /b 5

:write_error
echo.
echo ERROR: Failed to write or read back one or more Yandex Browser policies.
exit /b 1
