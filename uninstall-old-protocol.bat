@echo off
REM =========================================================================
REM Script de nettoyage des protocoles personnalises
REM - Supprime assist-msra:// et ctrl-dw:// (protocoles personnalises)
REM - Restaure dwrcc:// original (protocole natif Dameware)
REM
REM Usage: Ce script doit etre execute avec des privileges administrateur
REM        A executer AVANT d'installer les nouveaux protocoles
REM =========================================================================

REM Verification des privileges administrateur
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo ERREUR: Ce script necessite des privileges administrateur.
    echo Veuillez executer en tant qu'administrateur.
    pause
    exit /b 1
)

echo =========================================================================
echo Nettoyage des protocoles personnalises
echo =========================================================================
echo.

REM Suppression du protocole assist-msra://
echo Suppression du protocole assist-msra://...
reg delete "HKEY_CLASSES_ROOT\assist-msra" /f >nul 2>&1
if %errorLevel% equ 0 (
    echo [OK] Protocole assist-msra:// supprime.
) else (
    echo [INFO] Le protocole assist-msra:// n'etait pas installe.
)
echo.

REM Suppression du protocole ctrl-dw://
echo Suppression du protocole ctrl-dw://...
reg delete "HKEY_CLASSES_ROOT\ctrl-dw" /f >nul 2>&1
if %errorLevel% equ 0 (
    echo [OK] Protocole ctrl-dw:// supprime.
) else (
    echo [INFO] Le protocole ctrl-dw:// n'etait pas installe.
)
echo.

REM Suppression du protocole dwrcc:// personnalise (si present)
echo Suppression du protocole dwrcc:// personnalise...
reg delete "HKEY_CLASSES_ROOT\dwrcc" /f >nul 2>&1
echo [INFO] Protocole dwrcc:// supprime (prepare pour restauration).
echo.

REM Restauration du protocole dwrcc:// original (natif Dameware)
echo Restauration du protocole dwrcc:// original (natif Dameware)...
echo.

set "DWRCC_PATH=C:\Program Files (x86)\SolarWinds\Dameware Remote Support\DWRCC.exe"

REM Verification que Dameware est installe
if not exist "%DWRCC_PATH%" (
    echo [ATTENTION] Dameware non trouve a l'emplacement par defaut.
    echo             Le protocole dwrcc:// ne sera pas restaure.
    echo             Chemin recherche: "%DWRCC_PATH%"
    echo.
    goto :END_RESTORE
)

REM Creation de la cle principale dwrcc
reg add "HKEY_CLASSES_ROOT\dwrcc" /ve /t REG_SZ /d "URL:dwrcc Protocol" /f >nul 2>&1
reg add "HKEY_CLASSES_ROOT\dwrcc" /v "URL Protocol" /t REG_SZ /d "" /f >nul 2>&1

REM Icone par defaut
reg add "HKEY_CLASSES_ROOT\dwrcc\DefaultIcon" /ve /t REG_SZ /d "\"%DWRCC_PATH%\",1" /f >nul 2>&1

REM Commande d'execution (natif Dameware)
reg add "HKEY_CLASSES_ROOT\dwrcc\shell\open\command" /ve /t REG_SZ /d "\"%DWRCC_PATH%\" -c -WHDURL:%%1" /f >nul 2>&1

if %errorLevel% equ 0 (
    echo [OK] Protocole dwrcc:// original restaure avec succes.
    echo      Ce protocole est maintenant gere nativement par Dameware.
) else (
    echo [ERREUR] Impossible de restaurer le protocole dwrcc:// original.
)

:END_RESTORE
echo.

REM Suppression du script wrapper (s'il existe)
set "WRAPPER_PATH=%SystemRoot%\System32\remote-assist-wrapper.bat"
if exist "%WRAPPER_PATH%" (
    echo Suppression du script wrapper...
    del /f /q "%WRAPPER_PATH%" >nul 2>&1
    if %errorLevel% equ 0 (
        echo [OK] Script wrapper supprime.
    ) else (
        echo [ATTENTION] Impossible de supprimer le wrapper: %WRAPPER_PATH%
    )
) else (
    echo [INFO] Aucun script wrapper a supprimer.
)
echo.

echo =========================================================================
echo Nettoyage termine !
echo =========================================================================
echo.
echo Protocoles supprimes:
echo   - assist-msra:// (protocole personnalise)
echo   - ctrl-dw:// (protocole personnalise)
echo.
echo Protocole restaure:
echo   - dwrcc:// (protocole natif Dameware)
echo.
echo Vous pouvez maintenant installer les nouveaux protocoles en executant:
echo   install-assist-protocols.bat
echo.
pause
exit /b 0
