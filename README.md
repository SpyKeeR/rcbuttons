# Plugin GLPI - Boutons d'Assistance Externe

Plugin GLPI qui ajoute des boutons d'assistance directement sur la fiche ordinateur pour faciliter la prise de main à distance (CIPS assist-msra ou Dameware) selon le profil utilisateur.

## Fonctionnalités

- ✅ Affichage de boutons sur la fiche ordinateur
- ✅ Détection automatique du profil (CIPS ou Admin)
- ✅ Protocoles personnalisés : `assist-msra://` et `ctrl-dw://`
- ✅ Récupération automatique du nom de l'ordinateur
- ✅ Non-intrusif : aucune modification du core GLPI
- ✅ Compatible GLPI 11.0+

---

## Installation

### 1. Installation du plugin GLPI

1. **Copiez** le dossier du plugin dans `glpi/plugins/assistbutton`
2. **Activez** le plugin : Configuration > Plugins > Installer > Activer
3. Le fichier `assist-redirect.html` sera automatiquement copié dans le dossier `public/` du plugin

### 2. Installation des protocoles sur les postes clients

Déployez le script `install-assist-protocols.bat` sur les postes des techniciens via GPO ou manuellement.

Le script installe les protocoles suivants :
- `assist-msra://` pour Microsoft Remote Assistance
- `ctrl-dw://` pour Dameware Remote Control

**Déploiement via GPO :**
1. Copiez `install-assist-protocols.bat` sur un partage réseau
2. Créez une GPO : Configuration ordinateur > Stratégies > Paramètres Windows > Scripts > Démarrage
3. Ajoutez le script au démarrage de l'ordinateur

---

## Configuration

### Profils utilisateurs

Éditez `assets/js/assist-config.js.php` lignes 17-18 pour définir les profils autorisés :

```php
$cips_profile_ids = [9, 3];  // CIPS_Helpers (9) et Admin (3) voient Assistance CIPS
$admin_profile_ids = [3];    // Admin (3) voit Dameware
```

**Règles d'affichage :**
- **Profils CIPS** (ex: CIPS_Helpers, Admin) : Voit le bouton Assistance CIPS
- **Profils Admin** : Voit les deux boutons (CIPS + Dameware)

### Protocoles

Les boutons génèrent automatiquement des URLs vers `public/assist-redirect.html` avec les paramètres suivants :
- `protocol=assist-msra&computer=NOM_PC` pour Assistance CIPS
- `protocol=ctrl-dw&computer=NOM_PC` pour Contrôle Dameware

Le fichier `assist-redirect.html` déclenche ensuite le protocole personnalisé correspondant :
- `assist-msra://NOM_PC` → Lance `msra.exe`
- `ctrl-dw://NOM_PC` → Lance Dameware `DWRCC.exe`

---

## Structure du projet

```
assistbutton/
├── setup.php                          # Configuration principale
├── hook.php                           # Installation/désinstallation
├── install-assist-protocols.bat       # Script de déploiement des protocoles
├── public/                            # Dossier accessible via web
│   ├── assist-redirect.html           # Page de redirection des protocoles
│   └── assets/
│       ├── js/
│       │   ├── assist-config.js.php   # Configuration dynamique PHP
│       │   └── assist-button.js       # Script d'injection des boutons
│       └── css/
│           └── assist-button.css      # Styles des boutons
└── assets/                            # Sources (à copier vers public/)
    ├── js/
    └── css/
```

**Note importante :** Le dossier `public/` contient les fichiers accessibles via le serveur web. Les fichiers dans `assets/` sont les sources de développement.

---

## Dépannage

**Le bouton n'apparaît pas ?**
- Ouvrez F12 > Console, cherchez `[AssistButton]`
- Vérifiez que le plugin est activé dans GLPI
- Vérifiez que votre profil utilisateur est dans la liste des profils autorisés

**Le nom de l'ordinateur n'est pas récupéré ?**
- Vérifiez que le champ "Nom" est renseigné dans la fiche ordinateur
- Vérifiez dans la console que le nom détecté n'est pas "Ordinateur" (mot-clé filtré)

**Le protocole ne se lance pas ?**
- Vérifiez que le script `install-assist-protocols.bat` a été exécuté en tant qu'administrateur
- Vérifiez dans le registre : `HKEY_CLASSES_ROOT\assist-msra` et `HKEY_CLASSES_ROOT\ctrl-dw`
- Testez manuellement : Ouvrir `assist-msra://test` ou `ctrl-dw://test` dans un navigateur

---

## Personnalisation

- **Couleurs des boutons** : `public/assets/css/assist-button.css`
- **Position des boutons** : `public/assets/js/assist-button.js` fonction `findTargetContainer()`
- **Texte des boutons** : `public/assets/js/assist-button.js` fonction `createAssistButton()`
- **Profils autorisés** : `public/assets/js/assist-config.js.php` lignes 17-18

---

**Version** : 1.0.1  
**Auteur** : SpyKeeR  
**Licence** : GPLv3+
