@echo off
REM =========================================================================
REM Script d'installation des protocoles personnalises pour assistance
REM - assist-msra:// pour Microsoft Remote Assistance (msra.exe)
REM - ctrl-dw:// pour Dameware Remote Control (DWRCC.exe)
REM
REM Usage: Ce script doit etre execute avec des privileges administrateur
REM       Il peut etre deploye via GPO (scripts de demarrage ordinateur)
REM =========================================================================

REM Verification des privileges administrateur
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo ERREUR: Ce script necessite des privileges administrateur.
    echo Veuillez executer en tant qu'administrateur.
    pause
    exit /b 1
)

REM Definition des chemins
set "WRAPPER_PATH=%SystemRoot%\System32\remote-assist-wrapper.bat"
set "MSRA_PATH=%SystemRoot%\System32\msra.exe"
set "DWRCC_PATH=C:\Program Files (x86)\SolarWinds\Dameware Remote Support\DWRCC.exe"

echo =========================================================================
echo Installation des protocoles personnalises pour assistance
echo =========================================================================
echo.

REM Creation du script wrapper de parsing
echo Creation du script wrapper universel: %WRAPPER_PATH%
(
echo @echo off
echo REM =========================================================================
echo REM Wrapper universel pour les protocoles d'assistance a distance
echo REM Supporte : assist-msra:// et ctrl-dw://
echo REM =========================================================================
echo.
echo setlocal enabledelayedexpansion
echo.
echo REM Recuperation du parametre complet
echo set "FULL_URL=%%~1"
echo.
echo REM Detection du protocole utilise
echo set "PROTOCOL="
echo set "HOSTNAME="
echo.
echo REM Verification du protocole assist-msra://
echo echo !FULL_URL! ^| findstr /I "assist-msra://" ^>nul
echo if %%errorLevel%% equ 0 ^(
echo     set "PROTOCOL=MSRA"
echo     set "HOSTNAME=!FULL_URL:*assist-msra://=!"
echo ^)
echo.
echo REM Verification du protocole ctrl-dw://
echo echo !FULL_URL! ^| findstr /I "ctrl-dw://" ^>nul
echo if %%errorLevel%% equ 0 ^(
echo     set "PROTOCOL=DWRCC"
echo     set "HOSTNAME=!FULL_URL:*ctrl-dw://=!"
echo ^)
echo.
echo REM Suppression eventuelle du slash final
echo set "HOSTNAME=!HOSTNAME:/=!"
echo.
echo REM Verification que le protocole est reconnu
echo if "!PROTOCOL!"=="" ^(
echo     echo ERREUR: Protocole non reconnu dans l'URL: !FULL_URL!
echo     exit /b 1
echo ^)
echo.
echo REM Verification que le nom d'hote n'est pas vide
echo if "!HOSTNAME!"=="" ^(
echo     echo ERREUR: Aucun nom d'hote fourni dans l'URL
echo     exit /b 1
echo ^)
echo.
echo REM Chemins des executables
echo set "MSRA_EXE=C:\Windows\System32\msra.exe"
echo set "DWRCC_EXE=C:\Program Files (x86)\SolarWinds\Dameware Remote Support\DWRCC.exe"
echo.
echo REM Lancement selon le protocole
echo if "!PROTOCOL!"=="MSRA" ^(
echo     echo Lancement de Microsoft Remote Assistance vers: !HOSTNAME!
echo     start "" "!MSRA_EXE!" /offerRA "!HOSTNAME!"
echo ^) else if "!PROTOCOL!"=="DWRCC" ^(
echo     echo Lancement de Dameware Remote Control vers: !HOSTNAME!
echo     start "" "!DWRCC_EXE!" -c: -a:1 -h: -m:!HOSTNAME!
echo ^)
echo.
echo endlocal
) > "%WRAPPER_PATH%"

if not exist "%WRAPPER_PATH%" (
    echo ERREUR: Impossible de creer le fichier wrapper.
    pause
    exit /b 1
)

echo [OK] Script wrapper cree avec succes.
echo.

REM =========================================================================
REM Installation du protocole assist-msra://
REM =========================================================================

echo Installation du protocole assist-msra://...

REM Enregistrement du protocole dans le registre
REM Cle principale du protocole
reg add "HKEY_CLASSES_ROOT\assist-msra" /ve /t REG_SZ /d "URL:Assist MSRA Protocol" /f >nul
if %errorLevel% neq 0 (
    echo ERREUR: Impossible de creer la cle principale du protocole assist-msra.
    pause
    exit /b 1
)

reg add "HKEY_CLASSES_ROOT\assist-msra" /v "URL Protocol" /t REG_SZ /d "" /f >nul
if %errorLevel% neq 0 (
    echo ERREUR: Impossible d'ajouter la valeur URL Protocol.
    pause
    exit /b 1
)

REM Icone par defaut
reg add "HKEY_CLASSES_ROOT\assist-msra\DefaultIcon" /ve /t REG_SZ /d "\"%MSRA_PATH%\",0" /f >nul
if %errorLevel% neq 0 (
    echo ERREUR: Impossible de definir l'icone par defaut.
    pause
    exit /b 1
)

REM Commande d'execution
reg add "HKEY_CLASSES_ROOT\assist-msra\shell\open\command" /ve /t REG_SZ /d "\"%WRAPPER_PATH%\" \"%%1\"" /f >nul
if %errorLevel% neq 0 (
    echo ERREUR: Impossible de definir la commande d'execution.
    pause
    exit /b 1
)

echo [OK] Protocole assist-msra:// installe avec succes.
echo.

REM =========================================================================
REM Installation du protocole ctrl-dw://
REM =========================================================================

echo Installation du protocole ctrl-dw://...

REM Cle principale du protocole
reg add "HKEY_CLASSES_ROOT\ctrl-dw" /ve /t REG_SZ /d "URL:Control Dameware Protocol" /f >nul
if %errorLevel% neq 0 (
    echo ERREUR: Impossible de creer la cle principale du protocole ctrl-dw.
    pause
    exit /b 1
)

reg add "HKEY_CLASSES_ROOT\ctrl-dw" /v "URL Protocol" /t REG_SZ /d "" /f >nul
if %errorLevel% neq 0 (
    echo ERREUR: Impossible d'ajouter la valeur URL Protocol pour ctrl-dw.
    pause
    exit /b 1
)

REM Icone par defaut
reg add "HKEY_CLASSES_ROOT\ctrl-dw\DefaultIcon" /ve /t REG_SZ /d "\"%DWRCC_PATH%\",0" /f >nul
if %errorLevel% neq 0 (
    echo ERREUR: Impossible de definir l'icone par defaut pour ctrl-dw.
    pause
    exit /b 1
)

REM Commande d'execution
reg add "HKEY_CLASSES_ROOT\ctrl-dw\shell\open\command" /ve /t REG_SZ /d "\"%WRAPPER_PATH%\" \"%%1\"" /f >nul
if %errorLevel% neq 0 (
    echo ERREUR: Impossible de definir la commande d'execution pour ctrl-dw.
    pause
    exit /b 1
)

echo [OK] Protocole ctrl-dw:// installe avec succes.
echo.

echo =========================================================================
echo Installation terminee avec succes !
echo =========================================================================
echo.
echo Protocoles installes :
echo   [OK] assist-msra:// - Microsoft Remote Assistance
echo   [OK] ctrl-dw:// - Dameware Remote Control
echo.
echo Script wrapper universel : %WRAPPER_PATH%
echo.
echo Exemples d'utilisation depuis GLPI:
echo   assist-msra://nom-ordinateur.domain.local
echo   ctrl-dw://nom-ordinateur.domain.local
echo =========================================================================
echo.
pause
exit /b 0
