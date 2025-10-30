<?php
/**
 * Configuration JavaScript pour le plugin RCButtons (Remote Control Buttons)
 * Ce fichier injecte les variables de configuration dans le contexte JavaScript
 */

// Sécurité : vérifier que ce fichier est appelé par GLPI
if (!defined('GLPI_ROOT')) {
    die("Sorry. You can't access this file directly");
}

// Récupérer l'ID du profil actif
$profile_id = $_SESSION['glpiactiveprofile']['id'] ?? 0;
$profile_name = $_SESSION['glpiactiveprofile']['name'] ?? '';
$user_id = $_SESSION['glpiID'] ?? 0;

// ============================================================================
// CONFIGURATION DU PLUGIN - À PERSONNALISER SELON VOS BESOINS
// ============================================================================

// IDs des profils autorisés
$cips_profile_ids = [9, 3];  // CIPS_Helpers (9) et Admin (3) voient Assistance CIPS
$admin_profile_ids = [3];    // Admin (3) voit Dameware

// Activer/désactiver les logs dans la console du navigateur (true = activé, false = désactivé)
$enable_debug_logs = true;

// ============================================================================

$is_cips = in_array($profile_id, $cips_profile_ids);
$is_admin = in_array($profile_id, $admin_profile_ids);

// Générer le JavaScript
header('Content-Type: application/javascript; charset=UTF-8');
?>
// Configuration du plugin RCButtons
window.GLPI_RCBUTTONS_CONFIG = {
    isCIPSProfile: <?php echo $is_cips ? 'true' : 'false'; ?>,
    isAdminProfile: <?php echo $is_admin ? 'true' : 'false'; ?>,
    profileId: <?php echo intval($profile_id); ?>,
    profileName: '<?php echo addslashes($profile_name); ?>',
    userId: <?php echo intval($user_id); ?>,
    glpiRoot: '<?php echo $CFG_GLPI['root_doc'] ?? ''; ?>',
    debugMode: <?php echo $enable_debug_logs ? 'true' : 'false'; ?>
};

if (window.GLPI_RCBUTTONS_CONFIG.debugMode) {
    console.log('[RCButtons Config] Configuration chargée:', window.GLPI_RCBUTTONS_CONFIG);
}
