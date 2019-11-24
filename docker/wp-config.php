<?php

define('DISABLE_WP_CRON', true);

define('DB_NAME', getenv('WORDPRESS_DB_NAME'));
define('DB_USER', getenv('WORDPRESS_DB_USER'));
define('DB_PASSWORD', getenv('WORDPRESS_DB_PASSWORD'));
define('DB_HOST', getenv('WORDPRESS_DB_HOST'));

define('DB_CHARSET', 'utf8');
define('DB_COLLATE', '');

$table_prefix  = 'wp_';

define('WP_DEBUG', (bool) getenv('WP_DEBUG'));
define('WP_DEBUG_LOG', (bool) getenv('WP_DEBUG_LOG'));
define('WPLANG', (string) getenv('WPLANG'));


if (!defined('ABSPATH')) {
    define('ABSPATH', dirname(__FILE__) . '/');
}

define('AUTH_KEY', '');
define('AUTH_SALT', '');
define('SECURE_AUTH_KEY', '');
define('SECURE_AUTH_SALT', '');
define('LOGGED_IN_KEY', '');
define('LOGGED_IN_SALT', '');
define('NONCE_KEY', '');
define('NONCE_SALT', '');

require_once(ABSPATH . 'wp-settings.php');
