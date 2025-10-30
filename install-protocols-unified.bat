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

setlocal enabledelayedexpansion

REM Verification des droits administrateur
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo ============================================================================
    echo ERREUR : Ce script doit etre execute en tant qu'administrateur !
    echo ============================================================================
    echo.
    echo Faites un clic-droit sur le fichier et selectionnez :
    echo "Executer en tant qu'administrateur"
    echo.
    pause
    exit /b 1
)

echo.
echo ============================================================================
echo Installation des gestionnaires de protocoles - RCButtons Plugin
echo ============================================================================
echo.

REM ============================================================================
REM DETECTION DES EXECUTABLES
REM ============================================================================

echo [ETAPE 1/5] Detection des executables necessaires...
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

if exist "%DWRCC_PATH_1%" (
    set "DWRCC_PATH=%DWRCC_PATH_1%"
    set "DWRCC_FOUND=1"
    echo [OK] Dameware trouve : %DWRCC_PATH_1%
    goto :dwrcc_found
)
if exist "%DWRCC_PATH_2%" (
    set "DWRCC_PATH=%DWRCC_PATH_2%"
    set "DWRCC_FOUND=1"
    echo [OK] Dameware trouve : %DWRCC_PATH_2%
    goto :dwrcc_found
)
if exist "%DWRCC_PATH_3%" (
    set "DWRCC_PATH=%DWRCC_PATH_3%"
    set "DWRCC_FOUND=1"
    echo [OK] Dameware trouve : %DWRCC_PATH_3%
    goto :dwrcc_found
)
if exist "%DWRCC_PATH_4%" (
    set "DWRCC_PATH=%DWRCC_PATH_4%"
    set "DWRCC_FOUND=1"
    echo [OK] Dameware trouve : %DWRCC_PATH_4%
    goto :dwrcc_found
)
if exist "%DWRCC_PATH_5%" (
    set "DWRCC_PATH=%DWRCC_PATH_5%"
    set "DWRCC_FOUND=1"
    echo [OK] Dameware trouve : %DWRCC_PATH_5%
    goto :dwrcc_found
)
if exist "%DWRCC_PATH_6%" (
    set "DWRCC_PATH=%DWRCC_PATH_6%"
    set "DWRCC_FOUND=1"
    echo [OK] Dameware trouve : %DWRCC_PATH_6%
    goto :dwrcc_found
)

:dwrcc_found
if "%DWRCC_FOUND%"=="0" (
    echo [ATTENTION] Dameware ^(DWRCC.exe^) introuvable aux emplacements habituels :
    echo   - %DWRCC_PATH_1%
    echo   - %DWRCC_PATH_2%
    echo   - %DWRCC_PATH_3%
    echo   - %DWRCC_PATH_4%
    echo   - %DWRCC_PATH_5%
    echo   - %DWRCC_PATH_6%
    echo.
    echo Le gestionnaire ctrl-dw:// ne sera pas cree.
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
    echo [OK] Microsoft Remote Assistance trouve : %MSRA_PATH%
) else (
    echo [ATTENTION] Microsoft Remote Assistance ^(msra.exe^) introuvable.
    echo.
    echo Sur Windows Server, cette fonctionnalite doit etre activee via :
    echo   Gestionnaire de Serveur ^> Ajouter des roles et fonctionnalites
    echo   ^> Fonctionnalites ^> Assistance a distance
    echo.
    echo Le gestionnaire assist-msra:// ne sera pas cree.
    echo.
)

REM --- Detection de l'ancien wrapper (remote-assist-wrapper.bat) ---
set "OLD_WRAPPER_PATH=%SystemRoot%\System32\remote-assist-wrapper.bat"
set "OLD_WRAPPER_FOUND=0"

if exist "%OLD_WRAPPER_PATH%" (
    set "OLD_WRAPPER_FOUND=1"
    echo.
    echo [ATTENTION] Ancien wrapper detecte : %OLD_WRAPPER_PATH%
    echo.
    echo Ce fichier est une ancienne version du wrapper.
    echo Il est recommande de le supprimer si de nouveaux gestionnaires sont installes.
    echo.
)

echo.
pause

REM ============================================================================
REM GESTION DU HANDLER DWRCC:// ORIGINAL
REM ============================================================================

if "%DWRCC_FOUND%"=="1" (
    echo.
    echo [ETAPE 2/5] Verification du gestionnaire dwrcc:// original...
    echo.
    
    REM Verifier si dwrcc:// existe dans le registre
    reg query "HKEY_CLASSES_ROOT\dwrcc" >nul 2>&1
    if !errorlevel! equ 0 (
        REM dwrcc:// existe, verifier s'il pointe vers le wrapper
        for /f "tokens=2*" %%a in ('reg query "HKEY_CLASSES_ROOT\dwrcc\shell\open\command" /ve 2^>nul ^| findstr /i "REG_SZ"') do set "DWRCC_CMD=%%b"
        
        echo Le gestionnaire dwrcc:// existe deja.
        echo Commande actuelle : !DWRCC_CMD!
        echo.
        
        REM Verifier si c'est le wrapper ou l'original
        echo !DWRCC_CMD! | findstr /i "remote-assist-wrapper.bat" >nul
        if !errorlevel! equ 0 (
            echo Ce gestionnaire pointe vers un ancien wrapper ^(remote-assist-wrapper.bat^).
            echo Il est recommande de le nettoyer et le restaurer avec la configuration originale.
            echo.
            choice /C ON /M "Voulez-vous restaurer dwrcc:// a sa configuration originale"
            if !errorlevel! equ 1 (
                echo.
                echo Suppression de l'ancien gestionnaire dwrcc://...
                reg delete "HKEY_CLASSES_ROOT\dwrcc" /f >nul 2>&1
                
                echo Recreation du gestionnaire dwrcc:// original...
                REM Recreer avec la configuration originale de Dameware
                reg add "HKEY_CLASSES_ROOT\dwrcc" /ve /t REG_SZ /d "URL:dwrcc Protocol" /f >nul
                reg add "HKEY_CLASSES_ROOT\dwrcc" /v "URL Protocol" /t REG_SZ /d "" /f >nul
                reg add "HKEY_CLASSES_ROOT\dwrcc\DefaultIcon" /ve /t REG_SZ /d "\"%DWRCC_PATH%\",1" /f >nul
                reg add "HKEY_CLASSES_ROOT\dwrcc\shell" /f >nul
                reg add "HKEY_CLASSES_ROOT\dwrcc\shell\open" /f >nul
                reg add "HKEY_CLASSES_ROOT\dwrcc\shell\open\command" /ve /t REG_SZ /d "\"%DWRCC_PATH%\" -c -WHDURL:%%1" /f >nul
                
                echo [OK] Gestionnaire dwrcc:// restaure avec succes.
                echo.
            ) else (
                echo Restauration annulee. Le gestionnaire dwrcc:// reste inchange.
                echo.
            )
        ) else (
            echo Le gestionnaire dwrcc:// semble deja configure correctement.
            echo Aucune action necessaire.
            echo.
        )
    ) else (
        echo Le gestionnaire dwrcc:// n'existe pas. Creation recommandee...
        echo.
        choice /C ON /M "Voulez-vous creer le gestionnaire dwrcc:// original"
        if !errorlevel! equ 1 (
            echo.
            echo Creation du gestionnaire dwrcc:// original...
            reg add "HKEY_CLASSES_ROOT\dwrcc" /ve /t REG_SZ /d "URL:dwrcc Protocol" /f >nul
            reg add "HKEY_CLASSES_ROOT\dwrcc" /v "URL Protocol" /t REG_SZ /d "" /f >nul
            reg add "HKEY_CLASSES_ROOT\dwrcc\DefaultIcon" /ve /t REG_SZ /d "\"%DWRCC_PATH%\",1" /f >nul
            reg add "HKEY_CLASSES_ROOT\dwrcc\shell" /f >nul
            reg add "HKEY_CLASSES_ROOT\dwrcc\shell\open" /f >nul
            reg add "HKEY_CLASSES_ROOT\dwrcc\shell\open\command" /ve /t REG_SZ /d "\"%DWRCC_PATH%\" -c -WHDURL:%%1" /f >nul
            
            echo [OK] Gestionnaire dwrcc:// cree avec succes.
            echo.
        ) else (
            echo Creation annulee.
            echo.
        )
    )
    
    pause
) else (
    echo.
    echo [ETAPE 2/5] Gestionnaire dwrcc:// - Ignore ^(Dameware non detecte^)
    echo.
)

REM ============================================================================
REM GESTION DU HANDLER CTRL-DW:// (PLUGIN)
REM ============================================================================

if "%DWRCC_FOUND%"=="1" (
    echo.
    echo [ETAPE 3/5] Gestion du gestionnaire ctrl-dw:// ^(Plugin RCButtons^)...
    echo.
    
    REM Verifier si ctrl-dw:// existe deja
    reg query "HKEY_CLASSES_ROOT\ctrl-dw" >nul 2>&1
    if !errorlevel! equ 0 (
        echo Le gestionnaire ctrl-dw:// existe deja.
        echo.
        choice /C MUS /M "Action : [M]ettre a jour  [U]tiliser l'existant  [S]upprimer"
        
        if !errorlevel! equ 1 (
            echo.
            echo Mise a jour du gestionnaire ctrl-dw://...
            set "INSTALL_CTRL_DW=1"
        ) else if !errorlevel! equ 2 (
            echo.
            echo Le gestionnaire ctrl-dw:// existant sera conserve.
            set "INSTALL_CTRL_DW=0"
            echo.
        ) else (
            echo.
            echo Suppression du gestionnaire ctrl-dw://...
            reg delete "HKEY_CLASSES_ROOT\ctrl-dw" /f >nul 2>&1
            echo [OK] Gestionnaire ctrl-dw:// supprime.
            set "INSTALL_CTRL_DW=0"
            echo.
        )
    ) else (
        echo Le gestionnaire ctrl-dw:// n'existe pas. Installation...
        set "INSTALL_CTRL_DW=1"
        echo.
    )
    
    if "!INSTALL_CTRL_DW!"=="1" (
        REM Creation du gestionnaire ctrl-dw://
        reg add "HKEY_CLASSES_ROOT\ctrl-dw" /ve /t REG_SZ /d "URL:Control Dameware Protocol" /f >nul
        reg add "HKEY_CLASSES_ROOT\ctrl-dw" /v "URL Protocol" /t REG_SZ /d "" /f >nul
        reg add "HKEY_CLASSES_ROOT\ctrl-dw\DefaultIcon" /ve /t REG_SZ /d "\"%DWRCC_PATH%\",0" /f >nul
        reg add "HKEY_CLASSES_ROOT\ctrl-dw\shell" /f >nul
        reg add "HKEY_CLASSES_ROOT\ctrl-dw\shell\open" /f >nul
        reg add "HKEY_CLASSES_ROOT\ctrl-dw\shell\open\command" /ve /t REG_SZ /d "\"%SystemRoot%\System32\rcbuttons-wrapper.bat\" dameware \"%%1\"" /f >nul
        
        echo [OK] Gestionnaire ctrl-dw:// installe avec succes.
        echo.
    )
    
    pause
) else (
    echo.
    echo [ETAPE 3/5] Gestionnaire ctrl-dw:// - Ignore ^(Dameware non detecte^)
    echo.
)

REM ============================================================================
REM GESTION DU HANDLER ASSIST-MSRA:// (PLUGIN)
REM ============================================================================

if "%MSRA_FOUND%"=="1" (
    echo.
    echo [ETAPE 4/5] Gestion du gestionnaire assist-msra:// ^(Plugin RCButtons^)...
    echo.
    
    REM Verifier si assist-msra:// existe deja
    reg query "HKEY_CLASSES_ROOT\assist-msra" >nul 2>&1
    if !errorlevel! equ 0 (
        echo Le gestionnaire assist-msra:// existe deja.
        echo.
        choice /C MUS /M "Action : [M]ettre a jour  [U]tiliser l'existant  [S]upprimer"
        
        if !errorlevel! equ 1 (
            echo.
            echo Mise a jour du gestionnaire assist-msra://...
            set "INSTALL_ASSIST_MSRA=1"
        ) else if !errorlevel! equ 2 (
            echo.
            echo Le gestionnaire assist-msra:// existant sera conserve.
            set "INSTALL_ASSIST_MSRA=0"
            echo.
        ) else (
            echo.
            echo Suppression du gestionnaire assist-msra://...
            reg delete "HKEY_CLASSES_ROOT\assist-msra" /f >nul 2>&1
            echo [OK] Gestionnaire assist-msra:// supprime.
            set "INSTALL_ASSIST_MSRA=0"
            echo.
        )
    ) else (
        echo Le gestionnaire assist-msra:// n'existe pas. Installation...
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
        
        echo [OK] Gestionnaire assist-msra:// installe avec succes.
        echo.
    )
    
    pause
) else (
    echo.
    echo [ETAPE 4/5] Gestionnaire assist-msra:// - Ignore ^(MSRA non detecte^)
    echo.
)

REM ============================================================================
REM CREATION DU SCRIPT WRAPPER
REM ============================================================================

echo.
echo [ETAPE 5/5] Gestion du script wrapper...
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
    echo Aucun gestionnaire de protocole installe.
    echo Le script wrapper n'est pas necessaire.
    echo.
    
    REM Supprimer le wrapper s'il existe
    if exist "%WRAPPER_PATH%" (
        del /f /q "%WRAPPER_PATH%" >nul 2>&1
        echo [INFO] Ancien script wrapper supprime.
    )
    
    goto :end
)

REM Verifier si le wrapper existe deja
if exist "%WRAPPER_PATH%" (
    echo Le script wrapper existe deja : %WRAPPER_PATH%
    echo.
    choice /C MUS /M "Action : [M]ettre a jour  [U]tiliser l'existant  [S]upprimer"
    
    if !errorlevel! equ 1 (
        echo.
        echo Mise a jour du script wrapper...
        set "CREATE_WRAPPER=1"
    ) else if !errorlevel! equ 2 (
        echo.
        echo Le script wrapper existant sera conserve.
        set "CREATE_WRAPPER=0"
        echo.
        goto :end
    ) else (
        echo.
        echo Suppression du script wrapper...
        del /f /q "%WRAPPER_PATH%" >nul 2>&1
        echo [OK] Script wrapper supprime.
        set "CREATE_WRAPPER=0"
        echo.
        goto :end
    )
) else (
    echo Creation du script wrapper...
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
            echo     start "" "%DWRCC_PATH%" -c: -h: -m:"%%COMPUTER_NAME%%"
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
    
    echo [OK] Script wrapper cree : %WRAPPER_PATH%
    echo.
    echo Le wrapper contient uniquement la logique pour les protocoles installes :
    reg query "HKEY_CLASSES_ROOT\ctrl-dw" >nul 2>&1
    if !errorlevel! equ 0 echo   - Dameware ^(ctrl-dw://^)
    reg query "HKEY_CLASSES_ROOT\assist-msra" >nul 2>&1
    if !errorlevel! equ 0 echo   - Microsoft Remote Assistance ^(assist-msra://^)
    echo.
)

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
    echo ============================================================================
    echo Nettoyage de l'ancien wrapper
    echo ============================================================================
    echo.
    echo Un ancien wrapper a ete detecte : %OLD_WRAPPER_PATH%
    echo.
    if "%CREATE_WRAPPER%"=="1" (
        echo Un nouveau wrapper a ete cree. L'ancien wrapper n'est plus necessaire.
    ) else (
        echo Aucun gestionnaire de protocole n'est installe. L'ancien wrapper n'est plus necessaire.
    )
    echo.
    echo Il est recommande de le supprimer pour eviter toute confusion.
    echo.
    choice /C ON /M "Voulez-vous supprimer l'ancien wrapper"
    if !errorlevel! equ 1 (
        echo.
        echo Suppression de l'ancien wrapper...
        del /f /q "%OLD_WRAPPER_PATH%" >nul 2>&1
        if !errorlevel! equ 0 (
            echo [OK] Ancien wrapper supprime avec succes.
        ) else (
            echo [ERREUR] Impossible de supprimer l'ancien wrapper.
        )
        echo.
    ) else (
        echo.
        echo Suppression annulee. L'ancien wrapper a ete conserve.
        echo.
    )
    pause
)

:end
echo.
echo ============================================================================
echo Installation terminee avec succes !
echo ============================================================================
echo.
echo Recapitulatif :
echo.

if "%DWRCC_FOUND%"=="1" (
    echo [OK] Dameware detecte et configure
    reg query "HKEY_CLASSES_ROOT\dwrcc" >nul 2>&1
    if !errorlevel! equ 0 (
        echo      - Handler dwrcc:// : verifie/restaure
    ) else (
        echo      - Handler dwrcc:// : non cree
    )
    reg query "HKEY_CLASSES_ROOT\ctrl-dw" >nul 2>&1
    if !errorlevel! equ 0 (
        echo      - Handler ctrl-dw:// : installe/mis a jour
    ) else (
        echo      - Handler ctrl-dw:// : non cree
    )
) else (
    echo [--] Dameware non detecte - ctrl-dw:// non installe
)
echo.

if "%MSRA_FOUND%"=="1" (
    echo [OK] Microsoft Remote Assistance detecte et configure
    reg query "HKEY_CLASSES_ROOT\assist-msra" >nul 2>&1
    if !errorlevel! equ 0 (
        echo      - Handler assist-msra:// : installe/mis a jour
    ) else (
        echo      - Handler assist-msra:// : non cree
    )
) else (
    echo [--] MSRA non detecte - assist-msra:// non installe
)
echo.

if "%NEEDS_WRAPPER%"=="1" (
    if exist "%WRAPPER_PATH%" (
        echo [OK] Script wrapper : %WRAPPER_PATH%
    ) else (
        echo [--] Script wrapper non cree
    )
) else (
    echo [--] Script wrapper non necessaire
)
echo.

REM Afficher l'etat de l'ancien wrapper
if "%OLD_WRAPPER_FOUND%"=="1" (
    if exist "%OLD_WRAPPER_PATH%" (
        echo [INFO] Ancien wrapper conserve : %OLD_WRAPPER_PATH%
        echo        ^(Peut etre supprime manuellement si non utilise^)
    ) else (
        echo [OK] Ancien wrapper supprime : %OLD_WRAPPER_PATH%
    )
    echo.
)

echo Vous pouvez maintenant utiliser les boutons dans GLPI.
echo.
pause
endlocal
