# Résumé des Modifications - Plugin RCButtons

## Version 1.0.2 (28 janvier 2025)

### 🚀 Nouvelles Fonctionnalités

**Mode Debug Configurable :**
- Ajout d'une variable `$enable_debug_logs` dans `assist-config.js.php`
- Fonctions de logging conditionnelles : `debugLog()`, `debugWarn()`, `debugError()`
- Permet d'activer/désactiver les logs de la console facilement

**Interface Utilisateur Améliorée :**
- Nouvelle palette de couleurs CIPS : dégradé #26a69a → #00897b (thème médical turquoise)
- Titres de boutons personnalisés et explicites :
  - CIPS : "Offrir une assistance"
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
- [ ] Cliquer sur "Assistance CIPS" → Doit ouvrir `msra.exe`
- [ ] Cliquer sur "Contrôle Dameware" → Doit ouvrir Dameware
- [ ] Vérifier qu'il n'y a pas d'erreurs dans la console JS

---

## Compatibilité

- ✅ GLPI 11.0+
- ✅ Windows 10/11 (pour les protocoles)
- ✅ Navigateurs modernes (Chrome, Edge, Firefox)

---

**Date :** 28 octobre 2025  
**Version :** 1.0.1
