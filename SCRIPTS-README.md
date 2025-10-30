# 📜 Scripts d'Installation des Protocoles - RCButtons

## 📋 Vue d'ensemble

Ce dossier contient les scripts nécessaires pour installer et configurer les gestionnaires de protocoles personnalisés utilisés par le plugin RCButtons.

---

## 📦 Fichiers Disponibles

| Fichier | Description | Statut |
|---------|-------------|--------|
| **`install-protocols-unified.bat`** | ✅ **Script unifié intelligent** - Installation complète et interactive | **RECOMMANDÉ** |
| `install-assist-protocols.bat` | 🔄 Script original - Installation basique sans interaction | Ancien |
| `uninstall-old-protocol.bat` | 🗑️ Désinstallation des anciens protocoles | Utilitaire |
| `check-protocols-status.bat` | 🔍 Vérification de l'état des protocoles installés | Diagnostic |
| `dwrcc.reg` | 📄 Configuration de référence du protocole `dwrcc://` | Référence |

---

## 🚀 Installation (Recommandé)

### Utiliser le Script Unifié

Le script **`install-protocols-unified.bat`** est la solution complète et intelligente qui gère tous les cas de figure.

### Prérequis

- ✅ **Droits administrateur** requis
- ✅ Windows 7/8/10/11 ou Windows Server 2012+
- ⚠️ Dameware installé (optionnel, pour `ctrl-dw://`)
- ⚠️ Microsoft Remote Assistance disponible (optionnel, pour `assist-msra://`)

### Étapes

1. **Téléchargez** `install-protocols-unified.bat` depuis GitHub Releases
2. **Clic droit** → "Exécuter en tant qu'administrateur"
3. **Suivez les instructions** interactives à l'écran

---

## 🎯 Fonctionnalités du Script Unifié

### ✅ Détection Automatique

Le script détecte automatiquement :
- **Dameware** (`DWRCC.exe`) dans 6 chemins standards
- **MSRA** (`msra.exe`) dans `%SystemRoot%\System32\`
- **Ancien wrapper** (`remote-assist-wrapper.bat`) dans `%SystemRoot%\System32\`

Si un exécutable n'est pas trouvé, le protocole correspondant ne sera pas proposé à l'installation.

**Gestion de l'ancien wrapper :**
- Si détecté, le script propose sa suppression (recommandé)
- Suppression automatique proposée si :
  - Aucun handler n'est installé (ctrl-dw et assist-msra absents)
  - Un nouveau wrapper est créé (l'ancien devient obsolète)

### ✅ Gestion Intelligente du `dwrcc://` Original

Le script vérifie et gère le protocole natif de Dameware :

| Cas détecté | Action proposée |
|-------------|-----------------|
| ❌ N'existe pas | Proposition de création avec config originale |
| ⚠️ Pointe vers un wrapper | Proposition de nettoyage et restauration |
| ✅ Correct | Aucune modification |

### ✅ Installation Interactive des Protocoles Plugin

Pour `ctrl-dw://` et `assist-msra://` :

| État actuel | Options proposées |
|-------------|-------------------|
| ❌ N'existe pas | Installation automatique |
| ✅ Existe déjà | **[M]** Mettre à jour / **[U]** Conserver / **[S]** Supprimer |

### ✅ Génération Dynamique du Wrapper

Le script crée `%SystemRoot%\System32\rcbuttons-wrapper.bat` avec **uniquement** :
- La logique pour les protocoles **réellement installés**
- Les chemins d'exécutables **détectés sur le système**

**Avantages :**
- ✅ Pas de code inutile
- ✅ Génération adaptée au contexte
- ✅ Maintenance simplifiée

---

## 🔍 Vérification de l'Installation

### Utiliser le Script de Diagnostic

Après installation, vérifiez l'état avec :

```cmd
check-protocols-status.bat
```

**Affiche :**
- ✅ État de chaque protocole (installé/absent)
- 📋 Commandes enregistrées dans le registre
- 📂 Présence du wrapper
- 🔍 Détection des exécutables
- ⚠️ Détection de l'ancien wrapper (à supprimer)

---

## 🗑️ Désinstallation

### Désinstaller les Anciens Protocoles

Si vous avez une version antérieure installée :

```cmd
uninstall-old-protocol.bat
```

**Ce script :**
- Supprime `assist-msra://` et `ctrl-dw://` personnalisés
- Restaure `dwrcc://` original de Dameware
- Supprime l'ancien wrapper `remote-assist-wrapper.bat`

---

## 📝 Chemins de Recherche

### Dameware (`DWRCC.exe`)

Le script recherche dans l'ordre :

1. `C:\Program Files\SolarWinds\DameWare Remote Support\DWRCC.exe`
2. `C:\Program Files (x86)\SolarWinds\DameWare Remote Support\DWRCC.exe`
3. `C:\Program Files\SolarWinds\Dameware Mini Remote Control x64\DWRCC.exe`
4. `C:\Program Files (x86)\SolarWinds\Dameware Mini Remote Control\DWRCC.exe`
5. `C:\Program Files\DameWare Development\DameWare NT Utilities\DWRCC.exe`
6. `C:\Program Files\DameWare Development\DameWare Mini Remote Control 7.5\DWRCC.exe`

**Installation ailleurs ?** Éditez le script et ajoutez le chemin dans les variables `DWRCC_PATH_X`.

### Microsoft Remote Assistance (`msra.exe`)

Chemin standard : `%SystemRoot%\System32\msra.exe`

**Sur Windows Server**, activez via :
```
Gestionnaire de Serveur 
→ Ajouter des rôles et fonctionnalités 
→ Fonctionnalités 
→ Assistance à distance
```

---

## 💡 Exemples d'Utilisation

### Cas 1 : Installation Complète (Dameware + MSRA disponibles)

```cmd
install-protocols-unified.bat
```

**Déroulement :**
1. Détection de Dameware ✅ et MSRA ✅
2. Proposition de créer/restaurer `dwrcc://`
3. Installation de `ctrl-dw://` et `assist-msra://`
4. Création du wrapper avec les deux protocoles

**Résultat :**
- ✅ `dwrcc://` vérifié/créé
- ✅ `ctrl-dw://` installé
- ✅ `assist-msra://` installé
- ✅ Wrapper généré avec les deux protocoles

### Cas 2 : Installation Partielle (MSRA uniquement)

Si Dameware n'est pas installé :

```cmd
install-protocols-unified.bat
```

**Déroulement :**
1. Détection de Dameware ❌ et MSRA ✅
2. Étapes Dameware ignorées
3. Installation de `assist-msra://` uniquement
4. Création du wrapper avec MSRA uniquement

**Résultat :**
- ⚠️ `ctrl-dw://` non installé (Dameware absent)
- ✅ `assist-msra://` installé
- ✅ Wrapper généré avec MSRA uniquement

### Cas 3 : Mise à Jour d'un Protocole Existant

Si `ctrl-dw://` existe déjà :

```cmd
install-protocols-unified.bat
```

**Le script propose :**
- **[M]** Mettre à jour (réenregistre le protocole)
- **[U]** Utiliser l'existant (conserve l'actuel)
- **[S]** Supprimer (retire le protocole)

### Cas 4 : Nettoyage d'un Ancien Wrapper

Si `dwrcc://` pointe vers `remote-assist-wrapper.bat` :

**Le script détecte l'ancien wrapper et propose :**
- **[O]** Nettoyer et restaurer la configuration originale
- **[N]** Conserver l'état actuel

---

## ⚙️ Détails Techniques

### Structure du Wrapper Généré

Le wrapper `rcbuttons-wrapper.bat` est généré dynamiquement :

```batch
@echo off
setlocal enabledelayedexpansion

set "PROTOCOL_TYPE=%~1"
set "PROTOCOL_URL=%~2"

REM Extraction du nom d'ordinateur
set "COMPUTER_NAME=%PROTOCOL_URL:*://=%"
set "COMPUTER_NAME=%COMPUTER_NAME:/=%"

REM Logique pour Dameware (si installé)
if "%PROTOCOL_TYPE%"=="dameware" (
    start "" "C:\...\DWRCC.exe" -c: -h: -m:"%COMPUTER_NAME%"
    exit /b 0
)

REM Logique pour MSRA (si installé)
if "%PROTOCOL_TYPE%"=="msra" (
    start "" "C:\Windows\System32\msra.exe" /offerRA "%COMPUTER_NAME%"
    exit /b 0
)

REM Protocole non reconnu
echo ERREUR : Type de protocole non reconnu : %PROTOCOL_TYPE%
pause
exit /b 1
```

**Points clés :**
- ✅ Génération conditionnelle (uniquement les protocoles installés)
- ✅ Chemins absolus détectés automatiquement
- ✅ Gestion des espaces avec guillemets
- ✅ Extraction robuste du nom d'ordinateur

### Enregistrement dans le Registre

**Protocole `ctrl-dw://` :**
```
HKEY_CLASSES_ROOT\ctrl-dw
├── @ = "URL:Control Dameware Protocol"
├── URL Protocol = ""
├── DefaultIcon
│   └── @ = "C:\...\DWRCC.exe",0
└── shell\open\command
    └── @ = "C:\Windows\System32\rcbuttons-wrapper.bat" dameware "%1"
```

**Protocole `assist-msra://` :**
```
HKEY_CLASSES_ROOT\assist-msra
├── @ = "URL:Assistance MSRA Protocol"
├── URL Protocol = ""
├── DefaultIcon
│   └── @ = "C:\Windows\System32\msra.exe",0
└── shell\open\command
    └── @ = "C:\Windows\System32\rcbuttons-wrapper.bat" msra "%1"
```

---

## ⚠️ Dépannage

### "Ce script doit etre execute en tant qu'administrateur"

**Cause :** Droits insuffisants pour modifier le registre.

**Solution :**
- Clic droit sur le `.bat` → "Exécuter en tant qu'administrateur"

### "DWRCC.exe introuvable aux emplacements habituels"

**Cause :** Dameware n'est pas installé ou installé ailleurs.

**Solutions :**
1. Vérifier que Dameware est installé
2. Si installé ailleurs, éditer le script et ajouter le chemin
3. Continuer sans Dameware (seul MSRA sera installé)

### "msra.exe introuvable"

**Cause :** MSRA non disponible (courant sur Windows Server).

**Solution sur Windows Server :**
```
Gestionnaire de Serveur 
→ Ajouter des rôles et fonctionnalités 
→ Fonctionnalités 
→ Assistance à distance
```

### Le Protocole Ne Se Lance Pas

**Vérifications :**

1. **Protocole enregistré ?**
   ```cmd
   check-protocols-status.bat
   ```

2. **Wrapper présent ?**
   ```cmd
   dir %SystemRoot%\System32\rcbuttons-wrapper.bat
   ```

3. **Réinstallation :**
   ```cmd
   install-protocols-unified.bat
   ```
   → Choisir "Mettre à jour" pour les protocoles existants

### Conflit avec l'Ancien Wrapper

**Symptôme :** `remote-assist-wrapper.bat` encore présent dans `C:\Windows\System32\`.

**Détection :**
```cmd
check-protocols-status.bat
```

Le script affichera :
```
[5] Ancien Wrapper (remote-assist-wrapper.bat)
    Statut : [PRESENT]
    Chemin : C:\Windows\System32\remote-assist-wrapper.bat

    [!] ATTENTION : Cet ancien wrapper devrait etre supprime.
        Il n'est plus utilise par le plugin RCButtons.
        Reexecutez install-protocols-unified.bat pour le nettoyer.
```

**Solutions :**

1. **Méthode recommandée** : Réexécuter le script unifié
   ```cmd
   install-protocols-unified.bat
   ```
   → Le script détectera l'ancien wrapper et proposera sa suppression

2. **Méthode manuelle** : Utiliser le script de désinstallation
   ```cmd
   uninstall-old-protocol.bat
   ```

3. **Suppression directe** (si droits admin)
   ```cmd
   del /f "C:\Windows\System32\remote-assist-wrapper.bat"
   ```

**Important :** Ne confondez pas :
- ❌ `remote-assist-wrapper.bat` = Ancien wrapper (à supprimer)
- ✅ `rcbuttons-wrapper.bat` = Nouveau wrapper (à conserver)

---

## 🔄 Migration depuis l'Ancienne Version

### Étapes de Migration

1. **Sauvegarde** (optionnel mais recommandé)
   ```cmd
   check-protocols-status.bat > etat_avant_migration.txt
   ```

2. **Désinstallation de l'ancien système**
   ```cmd
   uninstall-old-protocol.bat
   ```

3. **Installation du nouveau système**
   ```cmd
   install-protocols-unified.bat
   ```

4. **Vérification**
   ```cmd
   check-protocols-status.bat
   ```

### Différences Clés

| Ancien | Nouveau (Unifié) |
|--------|------------------|
| Installation forcée | Installation interactive |
| Wrapper statique | Wrapper généré dynamiquement |
| Pas de vérification | Détection automatique des exécutables |
| `remote-assist-wrapper.bat` | `rcbuttons-wrapper.bat` |
| Pas de gestion de `dwrcc://` | Gestion intelligente de `dwrcc://` |

---

## 📚 Ressources

- **Documentation complète** : [INSTALL.md](INSTALL.md)
- **Changelog** : [CHANGELOG.md](CHANGELOG.md)
- **GitHub** : [https://github.com/SpyKeeR/rcbuttons](https://github.com/SpyKeeR/rcbuttons)

---

## 📄 Licence

Ces scripts font partie du plugin RCButtons pour GLPI.

**Licence :** GPLv3+  
**Auteur :** SpyKeeR  
**Copyright :** © 2025

---

## 💬 Support

Pour signaler un bug ou proposer une amélioration :

1. Vérifiez d'abord avec `check-protocols-status.bat`
2. Ouvrez une [Issue](https://github.com/SpyKeeR/rcbuttons/issues) sur GitHub
3. Joignez la sortie du script de diagnostic
4. Décrivez les messages d'erreur rencontrés
