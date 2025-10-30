/**
 * Plugin GLPI - Boutons d'Assistance Externe
 * Injection des boutons d'assistance sur la fiche ordinateur
 */

(function() {
    'use strict';
    
    // Attendre que le DOM soit chargé
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', start);
    } else {
        start();
    }

    // Démarrer : attendre la config GLPI puis initialiser
    function start() {
        // Vérifier qu'on est sur une page Computer (fiche ordinateur)
        if (!isComputerPage()) {
            return;
        }

        // Attendre que GLPI_RCBUTTONS_CONFIG soit défini (polling) avant d'injecter
        waitForConfig(5000, 200).then(function(defined) {
            if (!defined) {
                console.warn('[RCButtons] GLPI_RCBUTTONS_CONFIG non défini après attente');
            }
            // Petit délai supplémentaire pour laisser la page finir de charger
            setTimeout(function() {
                injectRCButtons();
            }, 200);
        });
    }

    // Attendre que la variable GLPI_RCBUTTONS_CONFIG soit définie (promise)
    function waitForConfig(timeoutMs, intervalMs) {
        return new Promise(function(resolve) {
            var waited = 0;
            if (typeof window.GLPI_RCBUTTONS_CONFIG !== 'undefined') {
                return resolve(true);
            }
            var timer = setInterval(function() {
                if (typeof window.GLPI_RCBUTTONS_CONFIG !== 'undefined') {
                    clearInterval(timer);
                    return resolve(true);
                }
                waited += intervalMs;
                if (waited >= timeoutMs) {
                    clearInterval(timer);
                    return resolve(false);
                }
            }, intervalMs);
        });
    }
    
    /**
     * Vérifier si on est sur une page de fiche ordinateur
     */
    function isComputerPage() {
        // Vérifier l'URL de manière stricte
        const url = window.location.href;
        const pathname = window.location.pathname;
        
        // Doit contenir computer.form.php ET avoir un ID
        const isComputerForm = pathname.indexOf('/computer.form.php') !== -1;
        const hasId = url.indexOf('id=') !== -1 && url.match(/[?&]id=(\d+)/);
        
        if (!isComputerForm || !hasId) {
            console.log('[RCButtons] Pas sur une page de fiche ordinateur');
            return false;
        }
        
        console.log('[RCButtons] Page ordinateur détectée');
        return true;
    }
    
    /**
     * Injecter les boutons de contrôle à distance
     */
    function injectRCButtons() {
        const config = window.GLPI_RCBUTTONS_CONFIG || {};
        const isCIPS = config.isCIPSProfile || false;
        const isAdmin = config.isAdminProfile || false;
        
        console.log('[RCButtons] Profil CIPS:', isCIPS);
        console.log('[RCButtons] Profil Admin:', isAdmin);
        
        // Récupérer le nom de l'ordinateur
        const computerName = getComputerName();
        
        if (!computerName) {
            console.log('[RCButtons] Impossible de récupérer le nom de l\'ordinateur');
            return;
        }
        
        console.log('[RCButtons] Ordinateur:', computerName);
        
        // Créer les liens dynamiquement
        const links = createRCButtonsLinks(computerName);
        console.log('[RCButtons] Liens générés:', links);
        
        // Trouver le conteneur principal
        const targetContainer = findTargetContainer();
        
        if (!targetContainer) {
            console.log('[RCButtons] Conteneur cible non trouvé');
            return;
        }
        
        // Afficher les boutons selon le profil
        let buttonCount = 0;
        
        // Si profil CIPS ou Admin : afficher bouton CIPS
        if (isCIPS) {
            const cipsLink = links.find(link => link.type === 'cips');
            if (cipsLink) {
                const button = createRCButton(cipsLink, 'cips');
                targetContainer.appendChild(button);
                buttonCount++;
                console.log('[RCButtons] Bouton CIPS ajouté');
            }
        }
        
        // Si profil Admin : afficher bouton Dameware
        if (isAdmin) {
            const damewareLink = links.find(link => link.type === 'dameware');
            if (damewareLink) {
                const button = createRCButton(damewareLink, 'dameware');
                targetContainer.appendChild(button);
                buttonCount++;
                console.log('[RCButtons] Bouton Dameware ajouté');
            }
        }
        
        if (buttonCount > 0) {
            console.log('[RCButtons] ' + buttonCount + ' bouton(s) injecté(s) avec succès');
        } else {
            console.log('[RCButtons] Aucun bouton à afficher pour ce profil');
        }
    }
    
    /**
     * Récupérer le nom de l'ordinateur depuis la page
     * Utilise plusieurs méthodes de fallback pour maximiser les chances de succès
     */
    function getComputerName() {
        console.log('[RCButtons] Recherche du nom d\'ordinateur...');
        
        // Méthode 1 : Chercher dans le breadcrumb ou card-title en priorité
        // Format attendu : "Ordinateur - INF-TEST-01 - ID 2" → on extrait "INF-TEST-01"
        const cardTitle = document.querySelector('.card-title, h2.card-title, .breadcrumb-item.active');
        if (cardTitle) {
            const titleText = cardTitle.textContent || cardTitle.innerText;
            // Extraire les segments séparés par " - " (avec espaces pour éviter de couper les tirets dans le nom)
            const segments = titleText.split(/\s+-\s+/).map(s => s.trim()).filter(s => s);
            // Le nom d'ordinateur est généralement le 2ème segment (index 1)
            // Format: ["Ordinateur", "INF-TEST-01", "ID 2"]
            if (segments.length >= 2) {
                const name = segments[1];
                console.log('[RCButtons] ✓ Nom trouvé dans card-title/breadcrumb (segment 2):', name);
                return name;
            }
        }
        
        // Méthode 2 : Liste de sélecteurs d'inputs à tester
        const selectors = [
            'input[name="name"]',                    // Sélecteur standard
            'input.form-control[name="name"]',       // Input Bootstrap avec name="name"
            'input[type="text"][name="name"]',       // Input texte avec name="name"
            'input[id*="name"][type="text"]',        // Input avec ID contenant "name"
            '#textfield_name',                       // ID textfield_name (anciennes versions)
            '.form-field-name input',                // Input dans un conteneur form-field-name
            'span.form-field-value'                  // Span avec la valeur (lecture seule)
        ];
        
        for (let i = 0; i < selectors.length; i++) {
            const element = document.querySelector(selectors[i]);
            if (element) {
                const name = element.value || element.textContent;
                if (name && name.trim()) {
                    console.log('[RCButtons] ✓ Nom trouvé via sélecteur "' + selectors[i] + '":', name.trim());
                    return name.trim();
                }
            }
        }
        
        // Méthode 3 : Parcourir TOUS les inputs avec name="name" (au cas où)
        const allNameInputs = document.querySelectorAll('input[name="name"]');
        for (let i = 0; i < allNameInputs.length; i++) {
            if (allNameInputs[i].value && allNameInputs[i].value.trim()) {
                const name = allNameInputs[i].value.trim();
                console.log('[RCButtons] ✓ Nom trouvé via querySelectorAll input[name="name"][' + i + ']:', name);
                return name;
            }
        }
        
        console.error('[RCButtons] ✗ Impossible de récupérer le nom de l\'ordinateur après toutes les tentatives');
        console.log('[RCButtons] Debug - Éléments trouvés:', {
            'input[name="name"]': document.querySelectorAll('input[name="name"]').length,
            'input.form-control': document.querySelectorAll('input.form-control').length,
            '.card-title': document.querySelectorAll('.card-title').length,
            'Premier input[name="name"] value': document.querySelector('input[name="name"]')?.value
        });
        return null;
    }
    
    /**
     * Créer les liens dynamiquement à partir du nom de l'ordinateur
     */
    function createRCButtonsLinks(computerName) {
        const glpiRoot = window.GLPI_RCBUTTONS_CONFIG?.glpiRoot || '';
        const baseUrl = glpiRoot + '/plugins/rcbuttons/assist-redirect.html';
        
        return [
            {
                url: baseUrl + '?protocol=assist-msra&computer=' + encodeURIComponent(computerName),
                text: 'Assistance CIPS',
                type: 'cips'
            },
            {
                url: baseUrl + '?protocol=ctrl-dw&computer=' + encodeURIComponent(computerName),
                text: 'Contrôle Dameware',
                type: 'dameware'
            }
        ];
    }
        
    /**
     * Trouver le conteneur où injecter le bouton
     */
    function findTargetContainer() {
        // Prioriser card-title puis d'autres zones
        const selectors = [
            '.card-title',
            '.card-header',
            'h2.card-title',
            '.page-header',
            '#mainformtable',
            '.asset-main-container',
            '.computer-form-header',
            '.panel-heading'
        ];
        
        for (let i = 0; i < selectors.length; i++) {
            const container = document.querySelector(selectors[i]);
            if (container) {
                console.log('[RCButtons] Conteneur trouvé:', selectors[i]);
                
                // Créer un wrapper si nécessaire
                let wrapper = container.querySelector('.rcbuttons-wrapper');
                if (!wrapper) {
                    wrapper = document.createElement('div');
                    wrapper.className = 'rcbuttons-wrapper';
                    wrapper.style.display = 'inline-flex';
                    wrapper.style.marginLeft = '15px';
                    wrapper.style.verticalAlign = 'middle';
                    
                    // Insérer à la fin du conteneur (à côté du titre)
                    container.appendChild(wrapper);
                }
                return wrapper;
            }
        }
        
        console.warn('[RCButtons] Aucun conteneur trouvé, utilisation du fallback');
        
        // Fallback: créer un conteneur flottant en haut à droite
        const fallback = document.createElement('div');
        fallback.className = 'rcbuttons-wrapper rcbuttons-floating';
        document.body.appendChild(fallback);
        return fallback;
    }
    
    /**
     * Créer le bouton de contrôle à distance
     */
    function createRCButton(link, type) {
        const button = document.createElement('a');
        button.href = link.url;
        // Ouvrir dans le même onglet au lieu d'un nouvel onglet
        button.target = '_self';
        button.className = 'rcbuttons-btn btn btn-primary rcbuttons-btn-' + type;
        
        // Icône et texte selon le type
        const icon = document.createElement('i');
        const text = document.createElement('span');
        
        if (type === 'cips') {
            button.title = 'Offrir une assistance';
            icon.className = 'fas fa-desktop';
            text.textContent = ' Assistance CIPS';
        } else if (type === 'dameware') {
            button.title = 'Lancer la prise de main à distance';
            icon.className = 'fas fa-headset';
            text.textContent = ' Contrôle via Dameware';
        }
        
        button.appendChild(icon);
        button.appendChild(text);
        
        // Ajouter un effet au survol
        button.addEventListener('mouseenter', function() {
            this.style.transform = 'scale(1.05)';
        });
        
        button.addEventListener('mouseleave', function() {
            this.style.transform = 'scale(1)';
        });
        
        return button;
    }
    
})();
