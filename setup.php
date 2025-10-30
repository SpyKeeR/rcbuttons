<?php
/**
 * Plugin GLPI - Boutons d'Assistance Externe (Remote Control Buttons)
 * 
 * @author     SpyKeeR
 * @copyright  Copyright (c) 2025
 * @license    GPLv3+
 */

define('PLUGIN_RCBUTTONS_VERSION', '1.0.2');
define('PLUGIN_RCBUTTONS_MIN_GLPI', '11.0.0');
define('PLUGIN_RCBUTTONS_MAX_GLPI', '11.0.99');

/**
 * Fonction d'initialisation du plugin
 */
function plugin_init_rcbuttons() {
    global $PLUGIN_HOOKS;

    $PLUGIN_HOOKS['csrf_compliant']['rcbuttons'] = true;
    
    // Enregistrer le hook pour ajouter JS/CSS
    // IMPORTANT: Le fichier de config doit être chargé EN PREMIER
    $PLUGIN_HOOKS['add_javascript']['rcbuttons'] = [
        'assets/js/assist-config.js.php',  // Configuration chargée en premier
        'assets/js/assist-button.js'        // Script principal ensuite
    ];
    
    $PLUGIN_HOOKS['add_css']['rcbuttons'] = [
        'assets/css/assist-button.css'
    ];
}

/**
 * Obtenir le nom du plugin
 */
function plugin_version_rcbuttons() {
    return [
        'name'           => 'Remote Control Buttons',
        'version'        => PLUGIN_RCBUTTONS_VERSION,
        'author'         => 'SpyKeeR',
        'license'        => 'GPLv3+',
        'homepage'       => 'https://github.com/SpyKeeR/rcbuttons',
        'requirements'   => [
            'glpi' => [
                'min' => PLUGIN_RCBUTTONS_MIN_GLPI,
                'max' => PLUGIN_RCBUTTONS_MAX_GLPI
            ]
        ]
    ];
}

/**
 * Vérifier les prérequis avant installation
 */
function plugin_rcbuttons_check_prerequisites() {
    if (version_compare(GLPI_VERSION, PLUGIN_RCBUTTONS_MIN_GLPI, 'lt')
        || version_compare(GLPI_VERSION, PLUGIN_RCBUTTONS_MAX_GLPI, 'gt')) {
        echo "Ce plugin nécessite GLPI >= " . PLUGIN_RCBUTTONS_MIN_GLPI . 
             " et < " . PLUGIN_RCBUTTONS_MAX_GLPI;
        return false;
    }
    return true;
}

/**
 * Vérifier la configuration du plugin
 */
function plugin_rcbuttons_check_config() {
    return true;
}
