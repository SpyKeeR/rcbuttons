# 🖱️ RCButtons - Plugin GLPI

**Remote Control Buttons** : Ajoutez des boutons d'assistance à distance directement sur les fiches ordinateurs de GLPI.

[![Version](https://img.shields.io/badge/version-1.0.2-blue.svg)](https://github.com/SpyKeeR/rcbuttons)
[![GLPI](https://img.shields.io/badge/GLPI-11.0.x-green.svg)](https://glpi-project.org/)
[![License](https://img.shields.io/badge/license-GPLv3-orange.svg)](LICENSE)

---

## ✨ Fonctionnalités

- 🎯 **Boutons intégrés** directement sur la fiche ordinateur
- 👤 **Basé sur les profils** : affichage personnalisé selon l'utilisateur
- 🔗 **Protocoles personnalisés** : `assist-msra://` (CIPS) et `ctrl-dw://` (Dameware)
- 🤖 **Extraction automatique** du nom d'ordinateur (méthode fiabilisée)
- 🎨 **Interface soignée** : design moderne avec animations et thème médical
- 🛠️ **Mode debug** configurable pour le diagnostic
- ✅ **Non-intrusif** : aucune modification du core GLPI
- 🌐 **Compatible** GLPI 11.0.0 à 11.0.99

---

## 🚀 Installation Rapide

### 1️⃣ Installation du plugin

```bash
cd /var/www/html/glpi/plugins/
git clone https://github.com/SpyKeeR/rcbuttons.git rcbuttons
```

Puis dans GLPI : **Configuration → Plugins → Installer → Activer**

### 2️⃣ Déploiement des protocoles

⚠️ Les fichiers `.bat` ne sont pas dans le dépôt (voir `.gitignore`).  
Téléchargez `install-assist-protocols.bat` depuis **GitHub Releases** ou l'historique Git.

**Déployez-le** sur les postes des techniciens :
- Via GPO (recommandé) : Script de démarrage
- Manuellement : Exécuter en administrateur

### 3️⃣ Configuration

Éditez `public/assets/js/assist-config.js.php` (lignes 22-26) :

```php
$cips_profile_ids = [9, 3];   // Profils CIPS
$admin_profile_ids = [3];      // Profils Admin (Dameware)
$enable_debug_logs = true;     // false en production
```

📖 **Documentation complète** : Voir [INSTALL.md](INSTALL.md)

---

## ⚙️ Comment ça marche ?

### Flux de fonctionnement

1. **Détection** : Le plugin détecte les fiches ordinateurs GLPI
2. **Extraction** : Récupère le nom depuis `.card-title` (méthode simplifiée)
3. **Injection** : Ajoute les boutons selon le profil utilisateur
4. **Redirection** : Clic → `assist-redirect.html?protocol=X&computer=NOM`
5. **Lancement** : Détection du protocole → Outil lancé ou message d'erreur

### Protocoles personnalisés

| Bouton | Protocole | Outil lancé | Profils |
|--------|-----------|-------------|---------|
| **Assistance CIPS** | `assist-msra://` | `msra.exe` | CIPS + Admin |
| **Contrôle Dameware** | `ctrl-dw://` | `DWRCC.exe` | Admin seul |

### Règles d'affichage

- **Profils CIPS** (`$cips_profile_ids`) : Voient le bouton CIPS
- **Profils Admin** (`$admin_profile_ids`) : Voient les deux boutons

---

## 📁 Structure du Projet

```
rcbuttons/
├── setup.php                          # Plugin GLPI principal
├── hook.php                           # Hooks installation/désinstallation
├── version.json                       # Métadonnées de version
├── CHANGELOG.md                       # Historique des versions
├── INSTALL.md                         # Guide d'installation détaillé
├── .gitignore                         # Exclusion des .bat et .reg
├── public/                            # Fichiers web accessibles
│   ├── assist-redirect.html           # Page de lancement des protocoles
│   └── assets/
│       ├── js/
│       │   ├── assist-config.js.php   # Configuration (PHP → JS)
│       │   └── assist-button.js       # Logique d'injection
│       └── css/
│           └── assist-button.css      # Styles des boutons
└── [.bat files]                       # Non versionnés (voir Releases)
```

**Note :** Les fichiers `.bat` et `.reg` sont exclus du dépôt Git (`.gitignore`).  
Téléchargez-les depuis **GitHub Releases** ou recréez-les depuis l'historique.

---

## 🐛 Dépannage

### Les boutons n'apparaissent pas

1. **Activez le mode debug** : `$enable_debug_logs = true`
2. **Ouvrez la console** (F12) et cherchez `[RCButtons]`
3. **Vérifiez** :
   - Plugin activé dans GLPI
   - Vous êtes sur une fiche ordinateur
   - Votre profil est autorisé

### Le protocole ne se lance pas

**Message d'erreur** sur la page de redirection ?
→ Cliquez sur le **lien GitHub** dans le message d'erreur  
→ Téléchargez et exécutez `install-assist-protocols.bat` en admin  
→ Redémarrez le navigateur

---

## 📝 Changelog

Voir [CHANGELOG.md](CHANGELOG.md) pour l'historique complet des modifications.

**Version 1.0.2** (28 janvier 2025) :
- ✅ Mode debug configurable
- ✅ Interface utilisateur améliorée (nouveaux titres et couleurs)
- ✅ Extraction du nom d'ordinateur simplifiée et épurée
- ✅ Détection des protocoles avec page de feedback
- ✅ `.gitignore` pour exclusion des `.bat`

---

## 📄 Licence

Ce projet est sous licence **GPLv3+**.  
Voir [LICENSE](LICENSE) pour plus de détails.

---

## 👤 Auteur

**SpyKeeR**  
🔗 [GitHub](https://github.com/SpyKeeR/rcbuttons)

---

## 🤝 Contribution

Les contributions sont les bienvenues ! N'hésitez pas à :
- 🐛 Signaler des bugs via les [Issues](https://github.com/SpyKeeR/rcbuttons/issues)
- 💡 Proposer des améliorations
- 🔧 Soumettre des Pull Requests

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
