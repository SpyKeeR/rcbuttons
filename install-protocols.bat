@echo off
REM -------------------------------------------------------------------------
REM RCButtons plugin for GLPI - Protocol Handlers Installation (Unified)
REM -------------------------------------------------------------------------
REM
REM LICENSE
REM
REM This file is part of RCButtons.
REM
REM RCButtons is free software; you can redistribute it and/or modify
REM it under the terms of the GNU General Public License as published by
REM the Free Software Foundation; either version 3 of the License, or
REM (at your option) any later version.
REM
REM RCButtons is distributed in the hope that it will be useful,
REM but WITHOUT ANY WARRANTY; without even the implied warranty of
REM MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
REM GNU General Public License for more details.
REM
REM You should have received a copy of the GNU General Public License
REM along with RCButtons. If not, see <http://www.gnu.org/licenses/>.
REM -------------------------------------------------------------------------
REM @copyright Copyright (C) 2025 by SpyKeeR.
REM @license   GPLv3+ https://www.gnu.org/licenses/gpl-3.0.html
REM @link      https://github.com/SpyKeeR/rcbuttons
REM -------------------------------------------------------------------------

REM Verification des droits administrateur (PRIORITE 1)
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo ============================================================================
    echo                         ERREUR CRITIQUE
    echo ============================================================================
    echo.
    echo Ce script doit etre execute en tant qu'administrateur !
    echo.
    echo Faites un clic-droit sur le fichier et selectionnez :
    echo "Executer en tant qu'administrateur"
    echo.
    pause
    exit /b 1
)

REM Verification et activation du support ANSI (PRIORITE 2)
REM Verifier si VirtualTerminalLevel existe et vaut 1
set "ANSI_ADDED_BY_SCRIPT=0"
set "ANSI_CLEANUP_FLAG=%TEMP%\rcbuttons_ansi_cleanup.flag"

REM Verifier si le fichier temoin existe (indique qu'on a ajoute la cle)
if exist "%ANSI_CLEANUP_FLAG%" (
    set "ANSI_ADDED_BY_SCRIPT=1"
)

REM Verifier si la cle existe et vaut 1
reg query HKCU\Console /v VirtualTerminalLevel 2>nul | find "0x1" >nul
if errorlevel 1 (
    REM La cle n'existe pas ou n'est pas a 1, l'activer et relancer
    reg add HKCU\Console /v VirtualTerminalLevel /t REG_DWORD /d 1 /f >nul 2>&1
    
    REM Creer un fichier temoin pour indiquer qu'on doit nettoyer
    echo 1 > "%ANSI_CLEANUP_FLAG%"
    
    echo.
    echo [INFO] Support ANSI active. Relancement du script pour appliquer les couleurs...
    echo.
    timeout /t 2 /nobreak >nul
    
    REM Relancer le script dans une nouvelle session CMD
    start "" cmd /c ""%~f0""
    exit /b 0
)

REM Definition du caractere ESC pour les codes ANSI (ASCII 27)
REM Effectue AVANT setlocal pour garantir l'expansion immediate
for /F %%a in ('echo prompt $E ^| cmd') do set "ESC=%%a"

REM Couleurs ANSI pour CMD.exe (EXPANSION IMMEDIATE avec %ESC%)
set "RED=%ESC%[91m"
set "GREEN=%ESC%[92m"
set "YELLOW=%ESC%[93m"
set "BLUE=%ESC%[94m"
set "MAGENTA=%ESC%[95m"
set "CYAN=%ESC%[96m"
set "WHITE=%ESC%[97m"
set "RESET=%ESC%[0m"
set "BOLD=%ESC%[1m"

setlocal enabledelayedexpansion

cls
echo.
echo %CYAN%============================================================================%RESET%
echo %CYAN%%BOLD%    _____   _____ ____        _   _                      %RESET%
echo %CYAN%%BOLD%   ^|  __ \ / ____^|  _ \      ^| ^| ^| ^|                     %RESET%
echo %CYAN%%BOLD%   ^| ^|__) ^| ^|    ^| ^|_) ^|_   _^| ^|_^| ^|_ ___  _ __  ___  %RESET%
echo %CYAN%%BOLD%   ^|  _  /^| ^|    ^|  _ ^<^| ^| ^| ^| __^| __/ _ \^| '_ \/ __^| %RESET%
echo %CYAN%%BOLD%   ^| ^| \ \^| ^|____^| ^|_) ^| ^|_^| ^| ^|_^| ^|^| (_) ^| ^| ^| \__ \ %RESET%
echo %CYAN%%BOLD%   ^|_^|  \_\\_____^|____/ \__,_^|\__^|\__\___/^|_^| ^|_^|___/ %RESET%
echo %CYAN%============================================================================%RESET%
echo %WHITE%%BOLD%          Installation des gestionnaires de protocoles%RESET%
echo %CYAN%============================================================================%RESET%
echo.

REM ============================================================================
REM DETECTION DES EXECUTABLES
REM ============================================================================

echo %MAGENTA%============================================================================%RESET%
echo %MAGENTA%%BOLD%                 [ETAPE 1/5] DETECTION DES EXECUTABLES%RESET%
echo %MAGENTA%============================================================================%RESET%
echo.

REM --- Detection de DWRCC.exe (Dameware) ---
set "DWRCC_FOUND=0"
set "DWRCC_PATH="

REM Chemins typiques de Dameware
set "DWRCC_PATH_1=C:\Program Files\SolarWinds\DameWare Remote Support\DWRCC.exe"
set "DWRCC_PATH_2=C:\Program Files (x86)\SolarWinds\DameWare Remote Support\DWRCC.exe"
set "DWRCC_PATH_3=C:\Program Files\SolarWinds\Dameware Mini Remote Control x64\DWRCC.exe"
set "DWRCC_PATH_4=C:\Program Files (x86)\SolarWinds\Dameware Mini Remote Control\DWRCC.exe"
set "DWRCC_PATH_5=C:\Program Files\DameWare Development\DameWare NT Utilities\DWRCC.exe"
set "DWRCC_PATH_6=C:\Program Files\DameWare Development\DameWare Mini Remote Control 7.5\DWRCC.exe"

if exist "!DWRCC_PATH_1!" (
    set "DWRCC_PATH=!DWRCC_PATH_1!"
    set "DWRCC_FOUND=1"
    echo %GREEN%[OK]%RESET% Dameware trouve : %CYAN%!DWRCC_PATH_1!%RESET%
    goto :dwrcc_found
)
if exist "!DWRCC_PATH_2!" (
    set "DWRCC_PATH=!DWRCC_PATH_2!"
    set "DWRCC_FOUND=1"
    echo %GREEN%[OK]%RESET% Dameware trouve : %CYAN%!DWRCC_PATH_2!%RESET%
    goto :dwrcc_found
)
if exist "!DWRCC_PATH_3!" (
    set "DWRCC_PATH=!DWRCC_PATH_3!"
    set "DWRCC_FOUND=1"
    echo %GREEN%[OK]%RESET% Dameware trouve : %CYAN%!DWRCC_PATH_3!%RESET%
    goto :dwrcc_found
)
if exist "!DWRCC_PATH_4!" (
    set "DWRCC_PATH=!DWRCC_PATH_4!"
    set "DWRCC_FOUND=1"
    echo %GREEN%[OK]%RESET% Dameware trouve : %CYAN%!DWRCC_PATH_4!%RESET%
    goto :dwrcc_found
)
if exist "!DWRCC_PATH_5!" (
    set "DWRCC_PATH=!DWRCC_PATH_5!"
    set "DWRCC_FOUND=1"
    echo %GREEN%[OK]%RESET% Dameware trouve : %CYAN%!DWRCC_PATH_5!%RESET%
    goto :dwrcc_found
)
if exist "!DWRCC_PATH_6!" (
    set "DWRCC_PATH=!DWRCC_PATH_6!"
    set "DWRCC_FOUND=1"
    echo %GREEN%[OK]%RESET% Dameware trouve : %CYAN%!DWRCC_PATH_6!%RESET%
    goto :dwrcc_found
)

:dwrcc_found
if "%DWRCC_FOUND%"=="0" (
    echo %YELLOW%[ATTENTION]%RESET% Dameware ^(DWRCC.exe^) introuvable aux emplacements habituels :
    echo   %RED%-%RESET% !DWRCC_PATH_1!
    echo   %RED%-%RESET% !DWRCC_PATH_2!
    echo   %RED%-%RESET% !DWRCC_PATH_3!
    echo   %RED%-%RESET% !DWRCC_PATH_4!
    echo   %RED%-%RESET% !DWRCC_PATH_5!
    echo   %RED%-%RESET% !DWRCC_PATH_6!
    echo.
    echo %YELLOW%Le gestionnaire ctrl-dw:// ne sera pas cree.%RESET%
    echo Si Dameware est installe ailleurs, editez ce script pour ajouter le chemin.
    echo.
)

REM --- Detection de MSRA.exe (Microsoft Remote Assistance) ---
set "MSRA_FOUND=0"
set "MSRA_PATH="

REM Chemin standard de MSRA
set "MSRA_PATH=%SystemRoot%\System32\msra.exe"

if exist "%MSRA_PATH%" (
    set "MSRA_FOUND=1"
    echo %GREEN%[OK]%RESET% Microsoft Remote Assistance trouve : %CYAN%!MSRA_PATH!%RESET%
) else (
    echo %YELLOW%[ATTENTION]%RESET% Microsoft Remote Assistance ^(msra.exe^) introuvable.
    echo.
    echo Sur Windows Server, cette fonctionnalite doit etre activee via :
    echo   %CYAN%Gestionnaire de Serveur ^> Ajouter des roles et fonctionnalites%RESET%
    echo   %CYAN%^> Fonctionnalites ^> Assistance a distance%RESET%
    echo.
    echo %YELLOW%Le gestionnaire assist-msra:// ne sera pas cree.%RESET%
    echo.
)

REM --- Detection de l'ancien wrapper (remote-assist-wrapper.bat) ---
set "OLD_WRAPPER_PATH=%SystemRoot%\System32\remote-assist-wrapper.bat"
set "OLD_WRAPPER_FOUND=0"

if exist "%OLD_WRAPPER_PATH%" (
    set "OLD_WRAPPER_FOUND=1"
    echo.
    echo %YELLOW%[ATTENTION]%RESET% Ancien wrapper detecte : %CYAN%!OLD_WRAPPER_PATH!%RESET%
    echo.
    echo Ce fichier est une ancienne version du wrapper.
    echo Il est recommande de le supprimer si de nouveaux gestionnaires sont installes.
    echo.
)

echo.
timeout /t 2 /nobreak >nul

REM ============================================================================
REM GESTION DU HANDLER DWRCC:// ORIGINAL
REM ============================================================================

if "%DWRCC_FOUND%"=="1" (
    echo.
    echo %MAGENTA%================================================================================%RESET%
    echo %MAGENTA%            %BOLD%[ETAPE 2/5] GESTIONNAIRE DWRCC:// ORIGINAL%RESET%
    echo %MAGENTA%================================================================================%RESET%
    echo.
    
    REM Verifier si dwrcc:// existe dans le registre
    reg query "HKEY_CLASSES_ROOT\dwrcc" >nul 2>&1
    if !errorlevel! equ 0 (
        REM dwrcc:// existe, verifier s'il pointe vers le wrapper
        for /f "tokens=2*" %%a in ('reg query "HKEY_CLASSES_ROOT\dwrcc\shell\open\command" /ve 2^>nul ^| findstr /i "REG_SZ"') do set "DWRCC_CMD=%%b"
        
        echo %YELLOW%Le gestionnaire dwrcc:// existe deja.%RESET%
        echo Commande actuelle : %CYAN%!DWRCC_CMD!%RESET%
        echo.
        
        REM Verifier si c'est le wrapper ou l'original
        echo !DWRCC_CMD! | findstr /i "remote-assist-wrapper.bat" >nul
        if !errorlevel! equ 0 (
            echo %RED%Ce gestionnaire pointe vers un ancien wrapper ^(remote-assist-wrapper.bat^).%RESET%
            echo Il est recommande de le nettoyer et le restaurer avec la configuration originale.
            echo.
            echo %YELLOW%Voulez-vous restaurer dwrcc:// a sa configuration originale ?%RESET%
            choice /C ON /N /M "Votre choix [O,N] : "
            if !errorlevel! equ 1 (
                echo.
                echo Suppression de l'ancien gestionnaire dwrcc://...
                reg delete "HKEY_CLASSES_ROOT\dwrcc" /f >nul 2>&1
                
                echo Recreation du gestionnaire dwrcc:// original...
                REM Recreer avec la configuration originale de Dameware
                reg add "HKEY_CLASSES_ROOT\dwrcc" /ve /t REG_SZ /d "URL:dwrcc Protocol" /f >nul
                reg add "HKEY_CLASSES_ROOT\dwrcc" /v "URL Protocol" /t REG_SZ /d "" /f >nul
                reg add "HKEY_CLASSES_ROOT\dwrcc\DefaultIcon" /ve /t REG_SZ /d "\"!DWRCC_PATH!\",1" /f >nul
                reg add "HKEY_CLASSES_ROOT\dwrcc\shell" /f >nul
                reg add "HKEY_CLASSES_ROOT\dwrcc\shell\open" /f >nul
                reg add "HKEY_CLASSES_ROOT\dwrcc\shell\open\command" /ve /t REG_SZ /d "\"!DWRCC_PATH!\" -c -WHDURL:%%1" /f >nul
                
                echo %GREEN%[OK]%RESET% Gestionnaire dwrcc:// restaure avec succes.
                echo.
                timeout /t 2 /nobreak >nul
            ) else (
                echo %YELLOW%Restauration annulee.%RESET% Le gestionnaire dwrcc:// reste inchange.
                echo.
                timeout /t 2 /nobreak >nul
            )
        ) else (
            echo %GREEN%Le gestionnaire dwrcc:// semble deja configure correctement.%RESET%
            echo Aucune action necessaire.
            echo.
            timeout /t 2 /nobreak >nul
        )
    ) else (
        echo %YELLOW%Le gestionnaire dwrcc:// n'existe pas.%RESET% Creation recommandee...
        echo.
        echo %CYAN%Voulez-vous creer le gestionnaire dwrcc:// original ?%RESET%
        choice /C ON /N /M "Votre choix [O,N] : "
        if !errorlevel! equ 1 (
            echo.
            echo Creation du gestionnaire dwrcc:// original...
            reg add "HKEY_CLASSES_ROOT\dwrcc" /ve /t REG_SZ /d "URL:dwrcc Protocol" /f >nul
            reg add "HKEY_CLASSES_ROOT\dwrcc" /v "URL Protocol" /t REG_SZ /d "" /f >nul
            reg add "HKEY_CLASSES_ROOT\dwrcc\DefaultIcon" /ve /t REG_SZ /d "\"!DWRCC_PATH!\",1" /f >nul
            reg add "HKEY_CLASSES_ROOT\dwrcc\shell" /f >nul
            reg add "HKEY_CLASSES_ROOT\dwrcc\shell\open" /f >nul
            reg add "HKEY_CLASSES_ROOT\dwrcc\shell\open\command" /ve /t REG_SZ /d "\"!DWRCC_PATH!\" -c -WHDURL:%%1" /f >nul
            
            echo %GREEN%[OK]%RESET% Gestionnaire dwrcc:// cree avec succes.
            echo.
            timeout /t 2 /nobreak >nul
        ) else (
            echo %YELLOW%Creation annulee.%RESET%
            echo.
            timeout /t 2 /nobreak >nul
        )
    )
) else (
    echo.
    echo %MAGENTA%================================================================================%RESET%
    echo %MAGENTA%            %BOLD%[ETAPE 2/5] GESTIONNAIRE DWRCC:// ORIGINAL%RESET%
    echo %MAGENTA%================================================================================%RESET%
    echo.
    echo %YELLOW%[IGNORE]%RESET% Dameware non detecte - dwrcc:// non traite
    echo.
    timeout /t 2 /nobreak >nul
)

REM ============================================================================
REM GESTION DU HANDLER CTRL-DW:// (PLUGIN)
REM ============================================================================

if "%DWRCC_FOUND%"=="1" (
    echo.
    echo %MAGENTA%================================================================================%RESET%
    echo %MAGENTA%          %BOLD%[ETAPE 3/5] GESTIONNAIRE CTRL-DW:// ^(PLUGIN^)%RESET%
    echo %MAGENTA%================================================================================%RESET%
    echo.
    
    REM Verifier si ctrl-dw:// existe deja
    reg query "HKEY_CLASSES_ROOT\ctrl-dw" >nul 2>&1
    if !errorlevel! equ 0 (
        echo %YELLOW%Le gestionnaire ctrl-dw:// existe deja.%RESET%
        echo.
        echo Action : %GREEN%[M]ettre a jour%RESET%  %BLUE%[U]tiliser l'existant%RESET%  %RED%[S]upprimer%RESET%
        choice /C MUS /N /M "Votre choix [M,U,S] : "
        
        if !errorlevel! equ 1 (
            echo.
            echo Mise a jour du gestionnaire ctrl-dw://...
            set "INSTALL_CTRL_DW=1"
        ) else if !errorlevel! equ 2 (
            echo.
            echo %GREEN%Le gestionnaire ctrl-dw:// existant sera conserve.%RESET%
            set "INSTALL_CTRL_DW=0"
            echo.
            timeout /t 2 /nobreak >nul
        ) else (
            echo.
            echo Suppression du gestionnaire ctrl-dw://...
            reg delete "HKEY_CLASSES_ROOT\ctrl-dw" /f >nul 2>&1
            echo %GREEN%[OK]%RESET% Gestionnaire ctrl-dw:// supprime.
            set "INSTALL_CTRL_DW=0"
            echo.
            timeout /t 2 /nobreak >nul
        )
    ) else (
        echo %CYAN%Le gestionnaire ctrl-dw:// n'existe pas.%RESET% Installation...
        set "INSTALL_CTRL_DW=1"
        echo.
    )
    
    if "!INSTALL_CTRL_DW!"=="1" (
        REM Creation du gestionnaire ctrl-dw://
        reg add "HKEY_CLASSES_ROOT\ctrl-dw" /ve /t REG_SZ /d "URL:Control Dameware Protocol" /f >nul
        reg add "HKEY_CLASSES_ROOT\ctrl-dw" /v "URL Protocol" /t REG_SZ /d "" /f >nul
        reg add "HKEY_CLASSES_ROOT\ctrl-dw\DefaultIcon" /ve /t REG_SZ /d "\"!DWRCC_PATH!\",0" /f >nul
        reg add "HKEY_CLASSES_ROOT\ctrl-dw\shell" /f >nul
        reg add "HKEY_CLASSES_ROOT\ctrl-dw\shell\open" /f >nul
        reg add "HKEY_CLASSES_ROOT\ctrl-dw\shell\open\command" /ve /t REG_SZ /d "\"%SystemRoot%\System32\rcbuttons-wrapper.bat\" dameware \"%%1\"" /f >nul
        
        echo %GREEN%[OK]%RESET% Gestionnaire ctrl-dw:// installe avec succes.
        echo.
        timeout /t 2 /nobreak >nul
    )
) else (
    echo.
    echo %MAGENTA%================================================================================%RESET%
    echo %MAGENTA%          %BOLD%[ETAPE 3/5] GESTIONNAIRE CTRL-DW:// ^(PLUGIN^)%RESET%
    echo %MAGENTA%================================================================================%RESET%
    echo.
    echo %YELLOW%[IGNORE]%RESET% Dameware non detecte - Recherche de gestionnaires orphelins...
    echo.
    
    REM Verifier si ctrl-dw:// existe malgre l'absence de DWRCC.exe
    reg query "HKEY_CLASSES_ROOT\ctrl-dw" >nul 2>&1
    if !errorlevel! equ 0 (
        echo %RED%[ATTENTION]%RESET% Gestionnaire ctrl-dw:// orphelin detecte ^(DWRCC.exe introuvable^).
        echo.
        echo Suppression automatique du gestionnaire orphelin...
        reg delete "HKEY_CLASSES_ROOT\ctrl-dw" /f >nul 2>&1
        echo %GREEN%[OK]%RESET% Gestionnaire ctrl-dw:// orphelin supprime avec succes.
        echo.
        timeout /t 2 /nobreak >nul
    ) else (
        echo %GREEN%[OK]%RESET% Aucun gestionnaire ctrl-dw:// orphelin detecte.
        echo.
        timeout /t 2 /nobreak >nul
    )
)

REM ============================================================================
REM GESTION DU HANDLER ASSIST-MSRA:// (PLUGIN)
REM ============================================================================

if "%MSRA_FOUND%"=="1" (
    echo.
    echo %MAGENTA%================================================================================%RESET%
    echo %MAGENTA%        %BOLD%[ETAPE 4/5] GESTIONNAIRE ASSIST-MSRA:// ^(PLUGIN^)%RESET%
    echo %MAGENTA%================================================================================%RESET%
    echo.
    
    REM Verifier si assist-msra:// existe deja
    reg query "HKEY_CLASSES_ROOT\assist-msra" >nul 2>&1
    if !errorlevel! equ 0 (
        echo %YELLOW%Le gestionnaire assist-msra:// existe deja.%RESET%
        echo.
        echo Action : %GREEN%[M]ettre a jour%RESET%  %BLUE%[U]tiliser l'existant%RESET%  %RED%[S]upprimer%RESET%
        choice /C MUS /N /M "Votre choix [M,U,S] : "
        
        if !errorlevel! equ 1 (
            echo.
            echo Mise a jour du gestionnaire assist-msra://...
            set "INSTALL_ASSIST_MSRA=1"
        ) else if !errorlevel! equ 2 (
            echo.
            echo %GREEN%Le gestionnaire assist-msra:// existant sera conserve.%RESET%
            set "INSTALL_ASSIST_MSRA=0"
            echo.
            timeout /t 2 /nobreak >nul
        ) else (
            echo.
            echo Suppression du gestionnaire assist-msra://...
            reg delete "HKEY_CLASSES_ROOT\assist-msra" /f >nul 2>&1
            echo %GREEN%[OK]%RESET% Gestionnaire assist-msra:// supprime.
            set "INSTALL_ASSIST_MSRA=0"
            echo.
            timeout /t 2 /nobreak >nul
        )
    ) else (
        echo %CYAN%Le gestionnaire assist-msra:// n'existe pas.%RESET% Installation...
        set "INSTALL_ASSIST_MSRA=1"
        echo.
    )
    
    if "!INSTALL_ASSIST_MSRA!"=="1" (
        REM Creation du gestionnaire assist-msra://
        reg add "HKEY_CLASSES_ROOT\assist-msra" /ve /t REG_SZ /d "URL:Assistance MSRA Protocol" /f >nul
        reg add "HKEY_CLASSES_ROOT\assist-msra" /v "URL Protocol" /t REG_SZ /d "" /f >nul
        reg add "HKEY_CLASSES_ROOT\assist-msra\DefaultIcon" /ve /t REG_SZ /d "\"%MSRA_PATH%\",0" /f >nul
        reg add "HKEY_CLASSES_ROOT\assist-msra\shell" /f >nul
        reg add "HKEY_CLASSES_ROOT\assist-msra\shell\open" /f >nul
        reg add "HKEY_CLASSES_ROOT\assist-msra\shell\open\command" /ve /t REG_SZ /d "\"%SystemRoot%\System32\rcbuttons-wrapper.bat\" msra \"%%1\"" /f >nul
        
        echo %GREEN%[OK]%RESET% Gestionnaire assist-msra:// installe avec succes.
        echo.
        timeout /t 2 /nobreak >nul
    )
) else (
    echo.
    echo %MAGENTA%================================================================================%RESET%
    echo %MAGENTA%        %BOLD%[ETAPE 4/5] GESTIONNAIRE ASSIST-MSRA:// ^(PLUGIN^)%RESET%
    echo %MAGENTA%================================================================================%RESET%
    echo.
    echo %YELLOW%[IGNORE]%RESET% MSRA non detecte - Recherche de gestionnaires orphelins...
    echo.
    
    REM Verifier si assist-msra:// existe malgre l'absence de MSRA.exe
    reg query "HKEY_CLASSES_ROOT\assist-msra" >nul 2>&1
    if !errorlevel! equ 0 (
        echo %RED%[ATTENTION]%RESET% Gestionnaire assist-msra:// orphelin detecte ^(MSRA.exe introuvable^).
        echo.
        echo Suppression automatique du gestionnaire orphelin...
        reg delete "HKEY_CLASSES_ROOT\assist-msra" /f >nul 2>&1
        echo %GREEN%[OK]%RESET% Gestionnaire assist-msra:// orphelin supprime avec succes.
        echo.
        timeout /t 2 /nobreak >nul
    ) else (
        echo %GREEN%[OK]%RESET% Aucun gestionnaire assist-msra:// orphelin detecte.
        echo.
        timeout /t 2 /nobreak >nul
    )
)

REM ============================================================================
REM CREATION DU SCRIPT WRAPPER
REM ============================================================================

echo.
echo %MAGENTA%================================================================================%RESET%
echo %MAGENTA%            %BOLD%[ETAPE 5/5] GESTION DU SCRIPT WRAPPER%RESET%
echo %MAGENTA%================================================================================%RESET%
echo.

set "WRAPPER_PATH=%SystemRoot%\System32\rcbuttons-wrapper.bat"
set "NEEDS_WRAPPER=0"

REM Determiner si on a besoin du wrapper
if "%DWRCC_FOUND%"=="1" if "!INSTALL_CTRL_DW!"=="1" set "NEEDS_WRAPPER=1"
if "%MSRA_FOUND%"=="1" if "!INSTALL_ASSIST_MSRA!"=="1" set "NEEDS_WRAPPER=1"

REM Verifier aussi si les handlers existent (meme s'ils n'ont pas ete recrees maintenant)
reg query "HKEY_CLASSES_ROOT\ctrl-dw" >nul 2>&1
if !errorlevel! equ 0 set "NEEDS_WRAPPER=1"
reg query "HKEY_CLASSES_ROOT\assist-msra" >nul 2>&1
if !errorlevel! equ 0 set "NEEDS_WRAPPER=1"

if "%NEEDS_WRAPPER%"=="0" (
    echo %YELLOW%Aucun gestionnaire de protocole installe.%RESET%
    echo Le script wrapper n'est pas necessaire.
    echo.
    
    REM Supprimer le wrapper s'il existe
    if exist "%WRAPPER_PATH%" (
        del /f /q "%WRAPPER_PATH%" >nul 2>&1
        echo %GREEN%[INFO]%RESET% Ancien script wrapper supprime.
    )
    
    timeout /t 2 /nobreak >nul
    goto :end
)

REM Verifier si le wrapper existe deja
if exist "%WRAPPER_PATH%" (
    echo %YELLOW%Le script wrapper existe deja :%RESET% %CYAN%!WRAPPER_PATH!%RESET%
    echo.
    
    REM Si le wrapper n'est plus necessaire, proposer seulement Utiliser ou Supprimer
    if "%NEEDS_WRAPPER%"=="0" (
        echo Action : %BLUE%[U]tiliser l'existant%RESET%  %RED%[S]upprimer%RESET%
        choice /C US /N /M "Votre choix [U,S] : "
        
        if !errorlevel! equ 1 (
            echo.
            echo %GREEN%Le script wrapper existant sera conserve.%RESET%
            set "CREATE_WRAPPER=0"
            echo.
            timeout /t 2 /nobreak >nul
            goto :end
        ) else (
            echo.
            echo Suppression du script wrapper...
            del /f /q "%WRAPPER_PATH%" >nul 2>&1
            echo %GREEN%[OK]%RESET% Script wrapper supprime.
            set "CREATE_WRAPPER=0"
            echo.
            timeout /t 2 /nobreak >nul
            goto :end
        )
    ) else (
        REM Le wrapper est necessaire, proposer toutes les options
        echo Action : %GREEN%[M]ettre a jour%RESET%  %BLUE%[U]tiliser l'existant%RESET%  %RED%[S]upprimer%RESET%
        choice /C MUS /N /M "Votre choix [M,U,S] : "
        
        if !errorlevel! equ 1 (
            echo.
            echo Mise a jour du script wrapper...
            set "CREATE_WRAPPER=1"
        ) else if !errorlevel! equ 2 (
            echo.
            echo %GREEN%Le script wrapper existant sera conserve.%RESET%
            set "CREATE_WRAPPER=0"
            echo.
            timeout /t 2 /nobreak >nul
            goto :end
        ) else (
            echo.
            echo %RED%ATTENTION :%RESET% Supprimer le wrapper alors que des gestionnaires sont installes
            echo peut empecher leur bon fonctionnement.
            echo.
            echo %YELLOW%Confirmer la suppression du wrapper ?%RESET%
            choice /C ON /N /M "Votre choix [O,N] : "
            if !errorlevel! equ 1 (
                echo.
                echo Suppression du script wrapper...
                del /f /q "%WRAPPER_PATH%" >nul 2>&1
                echo %GREEN%[OK]%RESET% Script wrapper supprime.
                set "CREATE_WRAPPER=0"
                echo.
                timeout /t 2 /nobreak >nul
                goto :end
            ) else (
                echo.
                echo %YELLOW%Suppression annulee.%RESET% Le wrapper existant sera conserve.
                set "CREATE_WRAPPER=0"
                echo.
                timeout /t 2 /nobreak >nul
                goto :end
            )
        )
    )
) else (
    echo %CYAN%Creation du script wrapper...%RESET%
    set "CREATE_WRAPPER=1"
    echo.
)

if "%CREATE_WRAPPER%"=="1" (
    REM Creer le script wrapper avec uniquement la logique necessaire
    (
    echo @echo off
    echo REM -------------------------------------------------------------------------
    echo REM RCButtons Plugin - Protocol Wrapper Script
    echo REM Automatically generated by install-protocols.bat
    echo REM -------------------------------------------------------------------------
    echo.
    echo setlocal enabledelayedexpansion
    echo.
    echo set "PROTOCOL_TYPE=%%~1"
    echo set "PROTOCOL_URL=%%~2"
    echo.
    echo REM Extraction du nom d'ordinateur depuis l'URL du protocole
    echo set "COMPUTER_NAME=%%PROTOCOL_URL:*://=%%"
    echo REM Suppression eventuelle du slash final
    echo set "COMPUTER_NAME=%%COMPUTER_NAME:/=%%"
    echo.
    ) > "%WRAPPER_PATH%"
    
    REM Ajouter la logique pour Dameware si necessaire
    reg query "HKEY_CLASSES_ROOT\ctrl-dw" >nul 2>&1
    if !errorlevel! equ 0 (
        if "%DWRCC_FOUND%"=="1" (
            (
            echo if "%%PROTOCOL_TYPE%%"=="dameware" ^(
            echo     REM Lancement de Dameware Remote Control
            echo     start "" "!DWRCC_PATH!" -c: -h: -m:%%COMPUTER_NAME%%
            echo     exit /b 0
            echo ^)
            echo.
            ) >> "%WRAPPER_PATH%"
        )
    )
    
    REM Ajouter la logique pour MSRA si necessaire
    reg query "HKEY_CLASSES_ROOT\assist-msra" >nul 2>&1
    if !errorlevel! equ 0 (
        if "%MSRA_FOUND%"=="1" (
            (
            echo if "%%PROTOCOL_TYPE%%"=="msra" ^(
            echo     REM Lancement de Microsoft Remote Assistance
            echo     start "" "%MSRA_PATH%" /offerRA "%%COMPUTER_NAME%%"
            echo     exit /b 0
            echo ^)
            echo.
            ) >> "%WRAPPER_PATH%"
        )
    )
    
    REM Ajouter la gestion d'erreur
    (
    echo REM Protocole non reconnu
    echo echo ERREUR : Type de protocole non reconnu : %%PROTOCOL_TYPE%%
    echo pause
    echo exit /b 1
    ) >> "%WRAPPER_PATH%"
    
    echo %GREEN%[OK]%RESET% Script wrapper cree : %CYAN%!WRAPPER_PATH!%RESET%
    echo.
    echo Le wrapper contient uniquement la logique pour les protocoles installes :
    reg query "HKEY_CLASSES_ROOT\ctrl-dw" >nul 2>&1
    if !errorlevel! equ 0 echo   %GREEN%[OK]%RESET% Dameware ^(ctrl-dw://^)
    reg query "HKEY_CLASSES_ROOT\assist-msra" >nul 2>&1
    if !errorlevel! equ 0 echo   %GREEN%[OK]%RESET% Microsoft Remote Assistance ^(assist-msra://^)
    echo.
    timeout /t 2 /nobreak >nul
)

:end
REM ============================================================================
REM NETTOYAGE DE L'ANCIEN WRAPPER (si necessaire)
REM ============================================================================

REM Determiner si on doit supprimer l'ancien wrapper
set "SHOULD_DELETE_OLD_WRAPPER=0"

REM Cas 1 : Aucun handler installe (ctrl-dw et assist-msra absents)
reg query "HKEY_CLASSES_ROOT\ctrl-dw" >nul 2>&1
set "HAS_CTRL_DW=!errorlevel!"
reg query "HKEY_CLASSES_ROOT\assist-msra" >nul 2>&1
set "HAS_ASSIST_MSRA=!errorlevel!"

if !HAS_CTRL_DW! neq 0 if !HAS_ASSIST_MSRA! neq 0 (
    REM Aucun handler installe, on peut supprimer l'ancien wrapper
    set "SHOULD_DELETE_OLD_WRAPPER=1"
)

REM Cas 2 : On a cree un nouveau wrapper (donc l'ancien est inutile)
if "%NEEDS_WRAPPER%"=="1" if "%CREATE_WRAPPER%"=="1" (
    set "SHOULD_DELETE_OLD_WRAPPER=1"
)

REM Supprimer l'ancien wrapper si necessaire
if "%OLD_WRAPPER_FOUND%"=="1" if "!SHOULD_DELETE_OLD_WRAPPER!"=="1" (
    echo.
    echo %YELLOW%================================================================================%RESET%
    echo %YELLOW%                 %BOLD%NETTOYAGE DE L'ANCIEN WRAPPER%RESET%
    echo %YELLOW%================================================================================%RESET%
    echo.
    echo Un ancien wrapper a ete detecte : %CYAN%!OLD_WRAPPER_PATH!%RESET%
    echo.
    if "%CREATE_WRAPPER%"=="1" (
        echo %GREEN%Un nouveau wrapper a ete cree.%RESET% L'ancien wrapper n'est plus necessaire.
    ) else (
        echo %YELLOW%Aucun gestionnaire de protocole n'est installe.%RESET% L'ancien wrapper n'est plus necessaire.
    )
    echo.
    echo Il est recommande de le supprimer pour eviter toute confusion.
    echo.
    echo %CYAN%Voulez-vous supprimer l'ancien wrapper ?%RESET%
    choice /C ON /N /M "Votre choix [O,N] : "
    if !errorlevel! equ 1 (
        echo.
        echo Suppression de l'ancien wrapper...
        del /f /q "%OLD_WRAPPER_PATH%" >nul 2>&1
        if !errorlevel! equ 0 (
            echo %GREEN%[OK]%RESET% Ancien wrapper supprime avec succes.
        ) else (
            echo %RED%[ERREUR]%RESET% Impossible de supprimer l'ancien wrapper.
        )
        echo.
        timeout /t 2 /nobreak >nul
    ) else (
        echo.
        echo %YELLOW%Suppression annulee.%RESET% L'ancien wrapper a ete conserve.
        echo.
        timeout /t 2 /nobreak >nul
    )
)

cls
echo.
echo %GREEN%================================================================================%RESET%
echo %GREEN%                                                                            %RESET%
echo %GREEN%              %BOLD%[OK]  INSTALLATION TERMINEE AVEC SUCCES  [OK]%RESET%
echo %GREEN%                                                                            %RESET%
echo %GREEN%================================================================================%RESET%
echo.
echo %CYAN%================================================================================%RESET%
echo %CYAN%                           %BOLD%RECAPITULATIF%RESET%
echo %CYAN%================================================================================%RESET%
echo.

REM Section Dameware
if "%DWRCC_FOUND%"=="1" (
    echo %WHITE%+-- %BOLD%DAMEWARE REMOTE CONTROL%RESET%
    reg query "HKEY_CLASSES_ROOT\dwrcc" >nul 2>&1
    if !errorlevel! equ 0 (
        echo %WHITE%^|  %GREEN%[OK]%RESET% Handler dwrcc:// : %GREEN%verifie/restaure%RESET%
    ) else (
        echo %WHITE%^|  %YELLOW%[ ]%RESET% Handler dwrcc:// : %YELLOW%non cree%RESET%
    )
    reg query "HKEY_CLASSES_ROOT\ctrl-dw" >nul 2>&1
    if !errorlevel! equ 0 (
        echo %WHITE%^|  %GREEN%[OK]%RESET% Handler ctrl-dw:// : %GREEN%installe/mis a jour%RESET%
    ) else (
        echo %WHITE%^|  %YELLOW%[ ]%RESET% Handler ctrl-dw:// : %YELLOW%non cree%RESET%
    )
    echo %WHITE%+--%RESET%
) else (
    echo %WHITE%+-- %BOLD%DAMEWARE REMOTE CONTROL%RESET%
    echo %WHITE%^|  %RED%[X]%RESET% Non detecte - %YELLOW%ctrl-dw://%RESET% non installe
    echo %WHITE%+--%RESET%
)
echo.

REM Section MSRA
if "%MSRA_FOUND%"=="1" (
    echo %WHITE%+-- %BOLD%MICROSOFT REMOTE ASSISTANCE%RESET%
    reg query "HKEY_CLASSES_ROOT\assist-msra" >nul 2>&1
    if !errorlevel! equ 0 (
        echo %WHITE%^|  %GREEN%[OK]%RESET% Handler assist-msra:// : %GREEN%installe/mis a jour%RESET%
    ) else (
        echo %WHITE%^|  %YELLOW%[ ]%RESET% Handler assist-msra:// : %YELLOW%non cree%RESET%
    )
    echo %WHITE%+--%RESET%
) else (
    echo %WHITE%+-- %BOLD%MICROSOFT REMOTE ASSISTANCE%RESET%
    echo %WHITE%^|  %RED%[X]%RESET% Non detecte - %YELLOW%assist-msra://%RESET% non installe
    echo %WHITE%+--%RESET%
)
echo.

REM Section Wrapper
echo %WHITE%+-- %BOLD%SCRIPT WRAPPER%RESET%
if "%NEEDS_WRAPPER%"=="1" (
    if exist "%WRAPPER_PATH%" (
        echo %WHITE%^|  %GREEN%[OK]%RESET% Wrapper actif : %CYAN%!WRAPPER_PATH!%RESET%
    ) else (
        echo %WHITE%^|  %RED%[X]%RESET% Wrapper non cree
    )
) else (
    echo %WHITE%^|  %YELLOW%[ ]%RESET% Wrapper non necessaire
)

REM Afficher l'etat de l'ancien wrapper
if "%OLD_WRAPPER_FOUND%"=="1" (
    if exist "%OLD_WRAPPER_PATH%" (
        echo %WHITE%^|  %YELLOW%[IGNORE]%RESET%  Ancien wrapper conserve : %CYAN%!OLD_WRAPPER_PATH!%RESET%
    ) else (
        echo %WHITE%^|  %GREEN%[OK]%RESET% Ancien wrapper supprime
    )
)
echo %WHITE%+--%RESET%
echo.

REM Section Nettoyage ANSI
echo %WHITE%+-- %BOLD%SUPPORT ANSI%RESET%
if "%ANSI_ADDED_BY_SCRIPT%"=="1" (
    REM Supprimer la cle VirtualTerminalLevel ajoutee temporairement
    reg delete HKCU\Console /v VirtualTerminalLevel /f >nul 2>&1
    if !errorlevel! equ 0 (
        echo %WHITE%^|  %GREEN%[OK]%RESET% Cle VirtualTerminalLevel nettoyee
        REM Supprimer le fichier temoin
        del /f /q "%ANSI_CLEANUP_FLAG%" >nul 2>&1
    ) else (
        echo %WHITE%^|  %YELLOW%[ATTENTION]%RESET% Cle VirtualTerminalLevel non supprimee
    )
) else (
    echo %WHITE%^|  %GREEN%[OK]%RESET% Aucun nettoyage ANSI necessaire
)
echo %WHITE%+--%RESET%
echo.

echo %GREEN%================================================================================%RESET%
echo.

REM Afficher le message d'utilisation seulement si le wrapper est actif et au moins un handler installe
set "HAS_HANDLERS=0"
reg query "HKEY_CLASSES_ROOT\ctrl-dw" >nul 2>&1
if !errorlevel! equ 0 set "HAS_HANDLERS=1"
reg query "HKEY_CLASSES_ROOT\assist-msra" >nul 2>&1
if !errorlevel! equ 0 set "HAS_HANDLERS=1"

if exist "%WRAPPER_PATH%" if "!HAS_HANDLERS!"=="1" (
    echo %BOLD%Vous pouvez maintenant utiliser le^(s^) bouton^(s^) dans GLPI.%RESET%
    echo.
) else (
    if not exist "%WRAPPER_PATH%" (
        echo %YELLOW%Le wrapper n'est pas installe. Les gestionnaires ne pourront pas fonctionner.%RESET%
        echo.
    ) else if "!HAS_HANDLERS!"=="0" (
        echo %YELLOW%Aucun gestionnaire de protocole n'est installe.%RESET%
        echo.
    )
)

echo %CYAN%Merci d'avoir utilise RCButtons Plugin !%RESET%
echo.
pause
endlocal
