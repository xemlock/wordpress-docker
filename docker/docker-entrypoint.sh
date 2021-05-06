#!/bin/sh

log () {
  echo "run.sh: $*"
}

# Configure MySQL client
CONFIG=~/.my.cnf

echo "[mysql]" > "$CONFIG"
echo "database=${WORDPRESS_DB_NAME}" >> "$CONFIG"
echo "" >> "$CONFIG"
echo "[client]" >> "$CONFIG"

case "${WORDPRESS_DB_HOST}" in
  *:*)
    echo "host="$(echo "$WORDPRESS_DB_HOST" | cut -d':' -f1) >> "$CONFIG"
    echo "port="$(echo "$WORDPRESS_DB_HOST" | cut -d':' -f2) >> "$CONFIG"
    ;;

  *)
    echo "host=${WORDPRESS_DB_HOST}" >> "$CONFIG"
    echo "port=${WORDPRESS_DB_PORT}" >> "$CONFIG"
    ;;
esac

echo "user=${WORDPRESS_DB_USER}" >> "$CONFIG"
echo "password=${WORDPRESS_DB_PASSWORD}" >> "$CONFIG"

# Download WordPress
if [ -z "$WORDPRESS_VERSION" ]; then
  WORDPRESS_VERSION=latest
fi

if [ ! -f "/var/www/index.php" ]; then
  log "Downloading WordPress ${WORDPRESS_VERSION}"
  curl -o /tmp/wordpress.tar.gz https://wordpress.org/wordpress-${WORDPRESS_VERSION}.tar.gz
  tar --strip-components=1 -zxf /tmp/wordpress.tar.gz -C /var/www
  cp /noop.php /var/www/wp-admin/includes/noop.php
fi

# Install WordPress
log 'Waiting for mysql to become ready'
while true; do
  DB_TABLES=$(mysql -e 'SHOW TABLES' 2>/dev/null)
  if [ $? -eq 0 ]; then
    break
  else
    sleep 1
  fi
done

WD=$(pwd)
cd /var/www/

PORT=8000

DB_VERSION=$(echo "SELECT option_value FROM wp_options WHERE option_name = 'db_version'" | mysql --skip-column-names 2>/dev/null)
if [ -z "$DB_VERSION" ]; then
  log 'Installing WordPress'

  wp core install --url=localhost:$PORT --title='My Blog' --admin_name=admin --admin_password=admin --admin_email=admin@localhost.com
  echo "UPDATE wp_options SET option_value = 'admin@localhost' WHERE option_name = 'admin_email'" | mysql
  wp option set blog_public 0
  wp rewrite structure '/%postname%/'
fi

# Set up WordPress
log 'Updating WordPress options'

# Ensure WP uses proper site url, in case database was imported
echo "UPDATE wp_options SET option_value = 'http://localhost:${PORT}' WHERE option_name IN ('home', 'siteurl');" | mysql

# Use current SMTP configuration from docker-compose.yml
echo "DELETE FROM wp_options WHERE option_name LIKE 'smtp_%';" > smtp.sql
echo "INSERT INTO wp_options (option_name, option_value) VALUES ('smtp_auth', '${SMTP_AUTH}');" >> smtp.sql
echo "INSERT INTO wp_options (option_name, option_value) VALUES ('smtp_host', '${SMTP_HOST}');" >> smtp.sql
echo "INSERT INTO wp_options (option_name, option_value) VALUES ('smtp_pass', '${SMTP_PASS}');" >> smtp.sql
echo "INSERT INTO wp_options (option_name, option_value) VALUES ('smtp_port', '${SMTP_PORT}');" >> smtp.sql
echo "INSERT INTO wp_options (option_name, option_value) VALUES ('smtp_ssl',  '${SMTP_SSL}');"  >> smtp.sql
echo "INSERT INTO wp_options (option_name, option_value) VALUES ('smtp_user', '${SMTP_USER}');" >> smtp.sql
mysql < smtp.sql
rm -f smtp.sql

cd "$WD"

# Apache
log 'Starting Apache server'
exec apache2ctl -DFOREGROUND
