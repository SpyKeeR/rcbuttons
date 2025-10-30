# Guide d'Installation - RCButtons Plugin

## 📋 Vue d'ensemble

Plugin GLPI qui ajoute des boutons d'assistance à distance directement sur les fiches ordinateurs.

**Version :** 1.0.2  
**Compatible :** GLPI 11.0.0 à 11.0.99

**Protocoles supportés :**
- `assist-msra://` → Microsoft Remote Assistance (CIPS)
- `ctrl-dw://` → Dameware Remote Control

---

## 🚀 Installation Rapide (5 minutes)

### Étape 1 : Installation du plugin GLPI

```bash
# Dans le dossier plugins de GLPI
cd /var/www/html/glpi/plugins/
git clone https://github.com/SpyKeeR/rcbuttons.git rcbuttons
# ou décompressez le ZIP dans rcbuttons/
```

**Via l'interface GLPI :**
1. Configuration → Plugins
2. Chercher "Remote Control Buttons"
3. Cliquer sur "Installer"
4. Cliquer sur "Activer"

✅ Les fichiers sont automatiquement accessibles via le dossier `public/`

---

### Étape 2 : Déploiement des protocoles sur les postes

⚠️ **Important** : Les fichiers `.bat` ne sont pas inclus dans le dépôt Git (voir `.gitignore`).  
Téléchargez `install-assist-protocols.bat` depuis GitHub Releases ou créez-le manuellement.

**Option A : Déploiement GPO (Recommandé)**

1. Télécharger le fichier `.bat` depuis GitHub
2. Le copier sur un partage réseau accessible
3. Créer une GPO :
   - Configuration ordinateur → Stratégies → Paramètres Windows → Scripts
   - Démarrage → Ajouter → `\\serveur\partage\install-assist-protocols.bat`
4. Appliquer la GPO sur l'OU des techniciens

**Option B : Installation manuelle**

1. Télécharger `install-assist-protocols.bat` depuis GitHub
2. Clic droit → "Exécuter en tant qu'administrateur"
3. Vérifier les messages de succès dans la console

**Option C : Création manuelle du .bat**

Voir le contenu du fichier dans le dépôt GitHub (historique Git) si besoin de le recréer.

---

### Étape 3 : Configuration des profils

Éditer `public/assets/js/assist-config.js.php` (lignes 22-26) :

```php
// === CONFIGURATION ===
// IDs des profils GLPI autorisés
$cips_profile_ids = [9, 3];     // Profils pouvant utiliser Assistance CIPS
$admin_profile_ids = [3];        // Profils pouvant utiliser Dameware

// Activer/désactiver les logs de debug dans la console
$enable_debug_logs = true;       // false en production recommandé
```

**Trouver l'ID d'un profil :**
```sql
SELECT id, name FROM glpi_profiles;
```

**Mode Debug :**
- `true` : Affiche les logs détaillés dans la console (F12)
- `false` : Désactive tous les logs (production)

---

## 🧪 Tests

### Test des protocoles

Ouvrir `test-protocols.html` (non inclus dans Git) dans un navigateur et cliquer sur les boutons de test.

### Test dans GLPI

1. Ouvrir une fiche ordinateur
2. Vérifier l'apparition des boutons selon votre profil
3. Ouvrir la console JS (F12) → Onglet Console
4. Chercher les logs `[RCButtons]` (si debug activé)
5. Cliquer sur un bouton → Page de redirection → Outil lancé
6. Si erreur : message avec lien vers le `.bat` d'installation sur GitHub

---

## 🔧 Dépannage

### Les boutons n'apparaissent pas

**Console JS (F12) - si `$enable_debug_logs = true` :**
```
[RCButtons] Page ordinateur détectée
[RCButtons] Profil CIPS: true
[RCButtons] Nom trouvé: PC-BUREAU-01
[RCButtons] Bouton CIPS ajouté
```

**Vérifications :**
- [ ] Plugin activé dans GLPI
- [ ] Vous êtes sur une fiche ordinateur (`computer.form.php?id=XXX`)
- [ ] Votre profil est dans la liste des profils autorisés
- [ ] Le mode debug est activé pour voir les logs

### Le protocole ne se lance pas

**Symptôme :** Message d'erreur sur la page de redirection

**Solution :**
1. Cliquer sur le lien GitHub dans le message d'erreur
2. Télécharger `install-assist-protocols.bat`
3. L'exécuter en tant qu'administrateur
4. Redémarrer le navigateur
- [ ] Le champ "Nom" est renseigné dans la fiche

---

### Le protocole ne se lance pas

**Vérifier l'installation du protocole :**

**PowerShell :**
```powershell
# Vérifier que les clés existent
Test-Path "HKCR:\assist-msra"    # Doit retourner True
Test-Path "HKCR:\ctrl-dw"         # Doit retourner True

# Vérifier le chemin du wrapper
Get-ItemProperty "HKCR:\assist-msra\shell\open\command" -Name "(default)"
Get-ItemProperty "HKCR:\ctrl-dw\shell\open\command" -Name "(default)"
```

**CMD :**
```cmd
reg query "HKEY_CLASSES_ROOT\assist-msra"
reg query "HKEY_CLASSES_ROOT\ctrl-dw"
```

**Si les clés n'existent pas :**
1. Réexécuter `install-assist-protocols.bat` **en tant qu'administrateur**
2. Vérifier les droits d'administration

---

### Le nom d'ordinateur est incorrect

**Symptôme :** Le plugin détecte "Ordinateur" au lieu du vrai nom

**Console JS :**
```
[AssistButton] Nom trouvé dans le titre: Ordinateur  ❌
```

**Solution :**
Le code corrigé filtre automatiquement "Ordinateur" et cherche dans `input[name="name"]` en priorité.

**Vérifier dans la console :**
```javascript
document.querySelector('input[name="name"]').value
```

Doit retourner le vrai nom, pas "Ordinateur".

---

## 📁 Structure des fichiers

```
assistbutton/
├── setup.php                          # Configuration principale du plugin
├── hook.php                           # Installation/désinstallation
├── composer.json                      # Dépendances (si nécessaire)
├── README.md                          # Documentation complète
├── CHANGELOG.md                       # Liste des corrections
├── MIGRATION.md                       # Guide de migration
├── .gitignore                         # Fichiers exclus du dépôt
│
├── install-assist-protocols.bat       # Script d'installation des protocoles
├── uninstall-old-protocol.bat         # Désinstallation de l'ancien dwrcc://
├── test-protocols.html                # Page de test interactive
│
├── public/                            # Dossier accessible via web
│   ├── assist-redirect.html           # Page de redirection
│   └── assets/
│       ├── js/
│       │   ├── assist-config.js.php   # Configuration dynamique
│       │   └── assist-button.js       # Script d'injection des boutons
│       └── css/
│           └── assist-button.css      # Styles des boutons
│
└── assets/                            # Sources (référence seulement)
    └── [anciens fichiers]
```

---

## 🔗 URLs importantes

**Dans GLPI :**
- Plugin : `/plugins/assistbutton/`
- Redirect : `/plugins/assistbutton/public/assist-redirect.html`
- JS Config : `/plugins/assistbutton/public/assets/js/assist-config.js.php`
- JS Main : `/plugins/assistbutton/public/assets/js/assist-button.js`
- CSS : `/plugins/assistbutton/public/assets/css/assist-button.css`

---

## 📝 Notes importantes

1. **Migration depuis l'ancienne version :**
   - Lire `MIGRATION.md` pour le guide complet
   - Exécuter `uninstall-old-protocol.bat` sur les postes
   - Redéployer `install-assist-protocols.bat`

2. **Protocole dwrcc:// :**
   - ❌ Ne plus utiliser (conflit système)
   - ✅ Utiliser `ctrl-dw://` à la place

3. **Dossier public/ :**
   - ✅ Seul dossier accessible via web
   - ⚠️ Ne pas modifier `assets/` (ancien, pour référence)

---

## 📞 Support

**Logs utiles :**
- Console JS du navigateur (F12)
- Journaux GLPI : `/files/_log/`
- Logs Windows : Observateur d'événements

**Commandes utiles :**
```powershell
# Vérifier les protocoles installés
Get-ItemProperty "HKCR:\assist-msra"
Get-ItemProperty "HKCR:\ctrl-dw"

# Tester manuellement
Start-Process "assist-msra://localhost"
Start-Process "ctrl-dw://localhost"
```

---

**Version :** 1.0.1  
**Date :** Octobre 2025  
**Auteur :** SpyKeeR
