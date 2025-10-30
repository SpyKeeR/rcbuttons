# Structure du Projet AssistLinks

```
assistbutton/
│
├── 📄 README.md                        # Documentation principale
├── 📄 INSTALL.md                       # Guide d'installation rapide
├── 📄 MIGRATION.md                     # Guide de migration depuis v0.x
├── 📄 CHANGELOG.md                     # Résumé des corrections et changements
├── 📄 LICENSE                          # Licence GPLv3+
├── 📄 .gitignore                       # Fichiers exclus du dépôt Git
├── 📄 composer.json                    # Métadonnées et dépendances
├── 📄 version.json                     # Version et changelog en JSON
│
├── 🔧 setup.php                        # Configuration principale du plugin GLPI
├── 🔧 hook.php                         # Hooks d'installation/désinstallation
│
├── 💾 install-assist-protocols.bat     # Installation des protocoles (assist-msra + ctrl-dw)
├── 💾 uninstall-old-protocol.bat       # Désinstallation de l'ancien dwrcc://
│
├── 🧪 test-protocols.html              # Page de test web interactive
├── 🧪 test-protocols.ps1               # Script PowerShell de vérification
│
├── 📁 public/                          # ✅ DOSSIER ACCESSIBLE VIA WEB
│   │
│   ├── 🌐 assist-redirect.html         # Page de redirection des protocoles
│   │
│   └── 📁 assets/
│       │
│       ├── 📁 js/
│       │   ├── assist-config.js.php    # Configuration dynamique (profils)
│       │   └── assist-button.js        # Script d'injection des boutons
│       │
│       └── 📁 css/
│           └── assist-button.css       # Styles des boutons
│
└── 📁 assets/                          # ⚠️ ANCIEN DOSSIER (référence seulement)
    │
    ├── 📁 js/
    │   ├── assist-config.js.php        # [Conservé pour développement]
    │   └── assist-button.js            # [Conservé pour développement]
    │
    └── 📁 css/
        └── assist-button.css           # [Conservé pour développement]
```

---

## 📊 Statistiques du Projet

| Type | Quantité |
|------|----------|
| Fichiers PHP | 3 |
| Fichiers JavaScript | 2 |
| Fichiers CSS | 1 |
| Fichiers HTML | 2 |
| Scripts Batch | 2 |
| Scripts PowerShell | 1 |
| Documentation | 5 |
| Configuration | 3 |

**Total : ~21 fichiers**

---

## 🔗 Flux de Fonctionnement

```
┌─────────────────────────────────────────────────────────────┐
│                    UTILISATEUR GLPI                          │
│              (Ouvre fiche ordinateur)                        │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│              GLPI charge le plugin                           │
│         setup.php → Enregistre JS/CSS                        │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│        assist-config.js.php charge la config                 │
│       (ID profil, droits, etc.)                              │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│         assist-button.js s'exécute                           │
│    1. Détecte la page (computer.form.php)                   │
│    2. Récupère le nom de l'ordinateur                       │
│    3. Vérifie le profil utilisateur                         │
│    4. Injecte les boutons appropriés                        │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│       UTILISATEUR clique sur un bouton                       │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│    Ouverture de assist-redirect.html                         │
│    avec paramètres : protocol + computer                     │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│   assist-redirect.html déclenche le protocole                │
│   - assist-msra://NOM_PC  OU                                 │
│   - ctrl-dw://NOM_PC                                         │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│   WINDOWS intercepte le protocole                            │
│   → Exécute remote-assist-wrapper.bat                        │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│   Le wrapper parse et lance l'application                    │
│   - msra.exe /offerRA NOM_PC                                 │
│   - DWRCC.exe -c: -a:2 -m:NOM_PC                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 🎯 Points Clés

### ✅ Avantages de cette architecture

1. **Séparation public/privé**
   - Fichiers web dans `public/`
   - Fichiers de développement dans `assets/`
   - Sécurité renforcée

2. **Installation automatisée**
   - `hook.php` copie automatiquement `assist-redirect.html`
   - Pas besoin de droits sur `/public` de GLPI

3. **Protocoles personnalisés**
   - `assist-msra://` pour MSRA
   - `ctrl-dw://` pour Dameware (évite le conflit avec `dwrcc://`)

4. **Configuration flexible**
   - Profils configurables via `assist-config.js.php`
   - Pas de base de données nécessaire

5. **Documentation complète**
   - README, INSTALL, MIGRATION
   - Scripts de test inclus

### ⚠️ Points d'attention

1. **Déploiement des protocoles**
   - Nécessite droits administrateur sur les postes clients
   - À faire via GPO idéalement

2. **Migration**
   - Redéployer `install-assist-protocols.bat`
   - Supprimer l'ancien `dwrcc://` si nécessaire

3. **Compatibilité**
   - GLPI 11.0+ uniquement
   - Windows 10/11 pour les protocoles

---

## 📝 Checklist de Déploiement

### Serveur GLPI

- [ ] Copier le plugin dans `/plugins/assistbutton/`
- [ ] Activer le plugin dans GLPI
- [ ] Vérifier que `public/assist-redirect.html` existe
- [ ] Configurer les profils dans `assist-config.js.php`

### Postes Clients (Techniciens)

- [ ] Déployer `install-assist-protocols.bat` (GPO recommandé)
- [ ] Vérifier l'installation avec `test-protocols.ps1`
- [ ] Tester dans GLPI sur une fiche ordinateur

### Tests

- [ ] Ouvrir une fiche ordinateur
- [ ] Vérifier l'apparition des boutons
- [ ] Cliquer sur un bouton
- [ ] Vérifier le lancement de l'application
- [ ] Consulter la console JS (F12) pour les logs

---

**Version :** 1.0.1  
**Date :** 28 octobre 2025  
**Auteur :** SpyKeeR
