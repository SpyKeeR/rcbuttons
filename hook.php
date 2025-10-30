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
