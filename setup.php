<?php
/**
 * -------------------------------------------------------------------------
 * RCButtons plugin for GLPI
 * -------------------------------------------------------------------------
 *
 * LICENSE
 *
 * This file is part of RCButtons.
 *
 * RCButtons is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 *
 * RCButtons is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with RCButtons. If not, see <http://www.gnu.org/licenses/>.
 * -------------------------------------------------------------------------
 * @copyright Copyright (C) 2025 by SpyKeeR.
 * @license   GPLv3+ https://www.gnu.org/licenses/gpl-3.0.html
 * @link      https://github.com/SpyKeeR/rcbuttons
 * -------------------------------------------------------------------------
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
