<?php
/**
 * Hooks du plugin Remote Control Buttons
 */

/**
 * Installation du plugin
 */
function plugin_rcbuttons_install() {
    // Le fichier assist-redirect.html est maintenant à la racine du plugin
    // Pas besoin de le copier ailleurs, il est directement accessible
    return true;
}

/**
 * Désinstallation du plugin
 */
function plugin_rcbuttons_uninstall() {
    // Pas de fichier à supprimer
    return true;
}
