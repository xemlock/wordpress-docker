<?php

/**
 * Noop functions for load-scripts.php and load-styles.php.
 *
 * This is a development-only replacement implementation for
 * wp-admin/includes/noop.php that does not interfere with PhpStorm
 * intellisense.
 */
foreach (
    array(
        '__',
        '_x',
        'add_filter',
        'esc_attr',
        'apply_filters',
        'get_option',
        'is_lighttpd_before_150',
        'add_action',
        'did_action',
        'do_action_ref_array',
        'get_bloginfo',
        'site_url',
        'admin_url',
        'home_url',
        'includes_url',
        'wp_guess_url',
        'json_encode',
    ) as $func
) {
    if (!function_exists($func)) {
        eval("function $func() {}");
    }
}

eval('
function is_admin() {return true;}
');

eval('
function get_file( $path ) {

    if ( function_exists("realpath") ) {
        $path = realpath( $path );
    }

    if ( ! $path || ! @is_file( $path ) ) {
        return "";
    }

    return @file_get_contents( $path );
}
');
