# Résumé des Modifications - Plugin RCButtons

## Version 1.1.2 (30 octobre 2025)

### 🔄 Améliorations et Refactorisation

**Anonymisation Complète du Code :**
- ✅ Remplacement de toutes les mentions "CIPS" par "MSRA" dans l'ensemble du projet
- 🔧 Refactorisation des variables JavaScript : `isCIPSProfile` → `isMSRAProfile`
- 🔧 Refactorisation des variables PHP : `$cips_profile_ids` → `$msra_profile_ids`
- 🔧 Mise à jour des commentaires : "CIPS_Helpers" → "Support_Helpers"
- 🎨 Mise à jour des classes CSS : `.rcbutton-cips` → `.rcbutton-msra`
- 📝 Mise à jour des textes utilisateur : "Assistance CIPS" → "Assistance MSRA"

**Documentation Mise à Jour :**
- 📚 README.md : Terminologie MSRA dans toutes les sections
- 📚 INSTALL.md : Instructions avec nouvelle nomenclature
- 📚 CHANGELOG.md : Historique corrigé
- 📚 composer.json : Keywords et description actualisés
- 📚 assist-redirect.html : Messages utilisateur mis à jour

**Fichiers Modifiés :**
- `public/assets/js/assist-button.js` (8 modifications)
- `public/assets/js/assist-config.js.php` (4 modifications)
- `public/assets/css/assist-button.css` (2 modifications)
- `public/assist-redirect.html` (1 modification)
- `composer.json` (2 modifications)
- Documentation complète (README, INSTALL, CHANGELOG)

---

## Version 1.1.0 (30 octobre 2025)

### 🎉 Refonte Majeure du Script d'Installation

**Script Unifié `install-protocols.bat` :**
- 🔄 Remplacement complet de `install-assist-protocols.bat`
- 📋 Gestion de 5 étapes : Détection → dwrcc:// → ctrl-dw:// → assist-msra:// → Wrapper
- 🎨 Interface colorée avec codes ANSI (support Windows 10/11/Server)
- 🔍 Détection automatique de 6 chemins DWRCC.exe avec ordre de priorité
- 🛡️ Vérification des droits administrateur avant toute opération

**Support ANSI Automatique :**
- ✨ Détection et activation automatique de VirtualTerminalLevel (Windows 10)
- 🔄 Auto-restart du script pour appliquer les couleurs
- 🧹 Nettoyage automatique de la clé registry en fin d'exécution (via fichier témoin)
- 🎯 Optimisation processeur avec expansions immédiates (%COLOR% au lieu de !COLOR!)

**Gestion des Gestionnaires Orphelins :**
- 🔎 Détection automatique de ctrl-dw:// sans DWRCC.exe
- 🔎 Détection automatique de assist-msra:// sans MSRA.exe
- 🗑️ Suppression forcée des gestionnaires orphelins
- ✅ Messages de confirmation pour chaque action

**Gestion du Protocole dwrcc:// Original :**
- 🔄 Détection des configurations pointant vers ancien wrapper
- ⚠️ Proposition de restauration à la configuration originale Dameware
- ✅ Vérification et validation de la configuration existante

**Wrapper Dynamique rcbuttons-wrapper.bat :**
- 📝 Génération automatique avec logique conditionnelle
- 🎯 Contient uniquement les protocoles installés (Dameware et/ou MSRA)
- 🧹 Nettoyage automatique de l'ancien remote-assist-wrapper.bat
- ⚙️ Gestion intelligente des besoins (création/mise à jour/suppression)

**Interface Utilisateur Améliorée :**
- 🎨 Codes couleurs : Vert (succès), Jaune (attention), Rouge (erreur), Cyan (info)
- 📊 Récapitulatif structuré avec sections (+-- DAMEWARE / MSRA / WRAPPER / SUPPORT ANSI)
- ⏱️ Timeouts automatiques (2 sec) au lieu de pause manuelle
- 🔄 Mode interactif avec choix [M]ettre à jour / [U]tiliser / [S]upprimer

**Corrections et Optimisations :**
- 🔧 Gestion correcte des espaces dans les chemins DWRCC.exe
- 📝 Messages contextuels selon l'état des installations
- 🎯 Affichage conditionnel du message "Vous pouvez utiliser les boutons GLPI"
- 🧪 Tests approfondis sur Windows 10, 11 et Server 2025

### 📚 Documentation

- ✅ Mise à jour complète du README.md avec instructions claires
- ✅ Mise à jour de INSTALL.md avec procédures détaillées
- ✅ Ajout d'avertissements sur l'installation OBLIGATOIRE sur chaque poste
- ✅ Création du .gitignore pour exclure les .bat et .md du clonage
- ✅ Documentation des nouvelles fonctionnalités dans version.json

---

## Version 1.0.2 (28 janvier 2025)

### 🚀 Nouvelles Fonctionnalités

**Mode Debug Configurable :**
- Ajout d'une variable `$enable_debug_logs` dans `assist-config.js.php`
- Fonctions de logging conditionnelles : `debugLog()`, `debugWarn()`, `debugError()`
- Permet d'activer/désactiver les logs de la console facilement

**Interface Utilisateur Améliorée :**
- Nouvelle palette de couleurs MSRA : dégradé #26a69a → #00897b (thème turquoise)
- Titres de boutons personnalisés et explicites :
  - MSRA : "Offrir une assistance"
  - Dameware : "Lancer la prise de main à distance"
- Ouverture des outils dans le même onglet (_self) au lieu de nouveaux onglets

**Détection des Gestionnaires de Protocole :**
- Page `assist-redirect.html` avec détection intelligente (événements blur/visibilitychange)
- Message de succès avec redirection automatique (3 secondes)
- Message d'erreur avec lien direct vers le `.bat` d'installation sur GitHub (15 secondes)
- Favicon ajouté pour la page de redirection

### 🔧 Optimisations

**Extraction du Nom d'Ordinateur Simplifiée :**
- Fonction `getComputerName()` épurée et réduite (~60 lignes → ~15 lignes)
- Une seule méthode fiable : extraction depuis `.card-title` avec séparateur " - "
- Préserve les tirets internes dans les noms d'ordinateurs (ex: PC-BUREAU-01)

**Gestion des Fichiers :**
- Ajout du `.gitignore` pour exclure les `.bat` et `.reg` des clones Git
- Permet toujours les modifications locales et push via VSCode

### 📚 Documentation

- Mise à jour du CHANGELOG avec la version 1.0.2
- Correction de la date de release (octobre 2025 → janvier 2025)
- Documentation claire des nouvelles fonctionnalités

---

## Version 1.0.1 (28 octobre 2025)

### 🔧 Améliorations

**Script de nettoyage amélioré (`uninstall-old-protocol.bat`) :**
- Supprime complètement `assist-msra://` et `ctrl-dw://` (protocoles personnalisés)
- Restaure automatiquement le protocole `dwrcc://` original (natif Dameware)
- Permet de repartir sur une base saine avant réinstallation
- Suppression du script wrapper `remote-assist-wrapper.bat`

---

## Version 1.0.0 (28 octobre 2025)

## Problèmes identifiés et solutions apportées

### ✅ 1. Conflit de protocole dwrcc://

**Problème :**
Le protocole `dwrcc://` existe déjà nativement dans le système, ce qui créait des conflits.

**Solution :**
- Création d'un nouveau protocole `ctrl-dw://` (Control Dameware)
- Mise à jour de tous les fichiers :
  - `install-assist-protocols.bat` : Enregistrement de `ctrl-dw://` au lieu de `dwrcc://`
  - `assist-redirect.html` : Accepte le paramètre `protocol=ctrl-dw`
  - `assets/js/assist-button.js` : Génère des liens avec `ctrl-dw`

**Fichiers modifiés :**
- ✏️ `install-assist-protocols.bat`
- ✏️ `public/assist-redirect.html`
- ✏️ `public/assets/js/assist-button.js`

---

### ✅ 2. Dossier assets non accessible depuis le web

**Problème :**
Le dossier `assets/` n'était pas accessible publiquement depuis l'interface web car il n'était pas dans un répertoire `public/`.

**Solution :**
- Création d'une nouvelle structure avec `public/assets/`
- Déplacement de tous les fichiers vers `public/`
- Mise à jour des chemins dans `setup.php`

**Nouvelle structure :**
```
assistbutton/
├── public/                          ← NOUVEAU : Accessible via web
│   ├── assist-redirect.html
│   └── assets/
│       ├── js/
│       │   ├── assist-config.js.php
│       │   └── assist-button.js
│       └── css/
│           └── assist-button.css
└── assets/                          ← ANCIEN : Conservé pour référence
```

**Fichiers modifiés :**
- ✏️ `setup.php` : Chemins vers `public/assets/`
- ✏️ `hook.php` : Copie de `assist-redirect.html` lors de l'installation

---

### ✅ 3. Extraction incorrecte du nom d'ordinateur

**Problème :**
Le script récupérait le mot "Ordinateur" (type d'asset) au lieu du nom réel de la machine depuis le titre de la page.

**Solution :**
- Priorité donnée au champ `input[name="name"]` qui contient le vrai nom
- Filtrage du mot-clé "Ordinateur" pour éviter ce piège
- Recherche multi-critères avec fallbacks

**Code modifié :**
```javascript
function getComputerName() {
    // 1. Priorité : Champ input name
    const nameInput = document.querySelector('input[name="name"]');
    if (nameInput && nameInput.value) return nameInput.value.trim();
    
    // 2. Autres sélecteurs possibles
    // ...
    
    // 3. Filtrer "Ordinateur" du titre
    if (titleMatch && titleMatch[1].toLowerCase() !== 'ordinateur') {
        return titleMatch[1];
    }
}
```

**Fichiers modifiés :**
- ✏️ `public/assets/js/assist-button.js` : Fonction `getComputerName()` réécrite

---

### ✅ 4. Déploiement de assist-redirect.html

**Problème :**
Le serveur IIS n'a pas les droits d'écriture sur `/public` de GLPI (racine).

**Solution :**
- Placement du fichier dans `public/` du plugin : `/plugins/assistbutton/public/`
- Copie automatique lors de l'installation via `hook.php`
- Les boutons pointent directement vers le plugin, pas vers la racine de GLPI

**Avantages :**
- ✅ Pas besoin de droits d'écriture sur GLPI
- ✅ Gestion automatique par le plugin
- ✅ URL stable : `/plugins/assistbutton/public/assist-redirect.html`

**Fichiers modifiés :**
- ✏️ `hook.php` : Fonction `plugin_assistbutton_install()` avec copie du fichier
- ✏️ `public/assets/js/assist-button.js` : URL dynamique vers le plugin

---

## Fichiers créés

| Fichier | Description |
|---------|-------------|
| `public/` | Nouveau dossier pour les fichiers accessibles via web |
| `.gitignore` | Exclusion de l'ancien dossier `assets/` |
| `MIGRATION.md` | Guide de migration détaillé |
| `uninstall-old-protocol.bat` | Script pour désinstaller l'ancien `dwrcc://` |
| `test-protocols.html` | Page de test interactive des protocoles |

---

## Actions requises pour déploiement

### Côté serveur GLPI

1. ✅ Désactiver l'ancien plugin
2. ✅ Remplacer par le nouveau code
3. ✅ Réactiver le plugin
4. ✅ Vérifier que `public/assist-redirect.html` existe

### Côté postes clients

1. ✅ Exécuter `uninstall-old-protocol.bat` (optionnel, pour nettoyer `dwrcc://`)
2. ✅ Exécuter `install-assist-protocols.bat` (version mise à jour)
3. ✅ Tester avec `test-protocols.html`

---

## Tests recommandés

- [ ] Ouvrir une fiche ordinateur dans GLPI
- [ ] Vérifier l'apparition des boutons selon le profil
- [ ] Vérifier dans la console JS que le bon nom est détecté (pas "Ordinateur")
- [ ] Cliquer sur "Assistance MSRA" → Doit ouvrir `msra.exe`
- [ ] Cliquer sur "Contrôle Dameware" → Doit ouvrir Dameware
- [ ] Vérifier qu'il n'y a pas d'erreurs dans la console JS

---

## Compatibilité

- ✅ GLPI 11.0+
- ✅ Windows 10/11 (pour les protocoles)
- ✅ Navigateurs modernes (Chrome, Edge, Firefox)