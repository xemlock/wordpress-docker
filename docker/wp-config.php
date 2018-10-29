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
define('WPLANG', (string) getenv('WPLANG'));

if (!defined('ABSPATH'))
    define('ABSPATH', dirname(__FILE__) . '/');

// https://exploitbox.io/vuln/WordPress-Exploit-4-6-RCE-CODE-EXEC-CVE-2016-10033.html
$_SERVER['HTTP_HOST'] = preg_replace('/[^-_.:\/a-z0-9]/', '', $_SERVER['HTTP_HOST']);

require_once(ABSPATH . 'wp-settings.php');
