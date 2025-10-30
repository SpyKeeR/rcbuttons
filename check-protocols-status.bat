@echo off
REM -------------------------------------------------------------------------
REM RCButtons plugin for GLPI - Protocol Handlers Status Check
REM -------------------------------------------------------------------------
REM
REM LICENSE
REM
REM This file is part of RCButtons.
REM -------------------------------------------------------------------------
REM @copyright Copyright (C) 2025 by SpyKeeR.
REM @license   GPLv3+ https://www.gnu.org/licenses/gpl-3.0.html
REM @link      https://github.com/SpyKeeR/rcbuttons
REM -------------------------------------------------------------------------

setlocal enabledelayedexpansion

echo.
echo ============================================================================
echo Verification des gestionnaires de protocoles - RCButtons Plugin
echo ============================================================================
echo.

REM Verification de dwrcc://
echo [1] Protocole dwrcc:// ^(Dameware original^)
reg query "HKEY_CLASSES_ROOT\dwrcc" >nul 2>&1
if !errorlevel! equ 0 (
    echo     Statut : [INSTALLE]
    for /f "tokens=2*" %%a in ('reg query "HKEY_CLASSES_ROOT\dwrcc\shell\open\command" /ve 2^>nul ^| findstr /i "REG_SZ"') do set "DWRCC_CMD=%%b"
    echo     Commande : !DWRCC_CMD!
) else (
    echo     Statut : [NON INSTALLE]
)
echo.

REM Verification de ctrl-dw://
echo [2] Protocole ctrl-dw:// ^(Plugin RCButtons - Dameware^)
reg query "HKEY_CLASSES_ROOT\ctrl-dw" >nul 2>&1
if !errorlevel! equ 0 (
    echo     Statut : [INSTALLE]
    for /f "tokens=2*" %%a in ('reg query "HKEY_CLASSES_ROOT\ctrl-dw\shell\open\command" /ve 2^>nul ^| findstr /i "REG_SZ"') do set "CTRL_DW_CMD=%%b"
    echo     Commande : !CTRL_DW_CMD!
) else (
    echo     Statut : [NON INSTALLE]
)
echo.

REM Verification de assist-msra://
echo [3] Protocole assist-msra:// ^(Plugin RCButtons - MSRA^)
reg query "HKEY_CLASSES_ROOT\assist-msra" >nul 2>&1
if !errorlevel! equ 0 (
    echo     Statut : [INSTALLE]
    for /f "tokens=2*" %%a in ('reg query "HKEY_CLASSES_ROOT\assist-msra\shell\open\command" /ve 2^>nul ^| findstr /i "REG_SZ"') do set "ASSIST_MSRA_CMD=%%b"
    echo     Commande : !ASSIST_MSRA_CMD!
) else (
    echo     Statut : [NON INSTALLE]
)
echo.

REM Verification du wrapper actuel
echo [4] Script Wrapper Actuel
set "WRAPPER_PATH=%SystemRoot%\System32\rcbuttons-wrapper.bat"
if exist "%WRAPPER_PATH%" (
    echo     Statut : [PRESENT]
    echo     Chemin : %WRAPPER_PATH%
) else (
    echo     Statut : [ABSENT]
)
echo.

REM Verification de l'ancien wrapper
echo [5] Ancien Wrapper ^(remote-assist-wrapper.bat^)
set "OLD_WRAPPER=%SystemRoot%\System32\remote-assist-wrapper.bat"
if exist "%OLD_WRAPPER%" (
    echo     Statut : [PRESENT]
    echo     Chemin : %OLD_WRAPPER%
    echo.
    echo     [!] ATTENTION : Cet ancien wrapper devrait etre supprime.
    echo         Il n'est plus utilise par le plugin RCButtons.
    echo         Reexecutez install-protocols-unified.bat pour le nettoyer.
) else (
    echo     Statut : [ABSENT]
)
echo.

REM Ligne de separation
echo ----------------------------------------------------------------------------
echo.

REM Verification des executables
echo [6] Executables detectes
echo.

set "DWRCC_PATH_1=C:\Program Files\SolarWinds\DameWare Remote Support\DWRCC.exe"
set "DWRCC_PATH_2=C:\Program Files (x86)\SolarWinds\DameWare Remote Support\DWRCC.exe"
set "DWRCC_PATH_3=C:\Program Files\SolarWinds\Dameware Mini Remote Control x64\DWRCC.exe"
set "DWRCC_PATH_4=C:\Program Files (x86)\SolarWinds\Dameware Mini Remote Control\DWRCC.exe"
set "DWRCC_PATH_5=C:\Program Files\DameWare Development\DameWare NT Utilities\DWRCC.exe"
set "DWRCC_PATH_6=C:\Program Files\DameWare Development\DameWare Mini Remote Control 7.5\DWRCC.exe"

echo     Dameware ^(DWRCC.exe^) :
if exist "%DWRCC_PATH_1%" (
    echo       [OK] %DWRCC_PATH_1%
) else if exist "%DWRCC_PATH_2%" (
    echo       [OK] %DWRCC_PATH_2%
) else if exist "%DWRCC_PATH_3%" (
    echo       [OK] %DWRCC_PATH_3%
) else if exist "%DWRCC_PATH_4%" (
    echo       [OK] %DWRCC_PATH_4%
) else if exist "%DWRCC_PATH_5%" (
    echo       [OK] %DWRCC_PATH_5%
) else if exist "%DWRCC_PATH_6%" (
    echo       [OK] %DWRCC_PATH_6%
) else (
    echo       [--] Non detecte
)
echo.

set "MSRA_PATH=%SystemRoot%\System32\msra.exe"
echo     Microsoft Remote Assistance ^(msra.exe^) :
if exist "%MSRA_PATH%" (
    echo       [OK] %MSRA_PATH%
) else (
    echo       [--] Non detecte
)
echo.

echo ============================================================================
echo Verification terminee
echo ============================================================================
echo.
pause
endlocal
