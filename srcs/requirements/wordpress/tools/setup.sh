#!/bin/bash

# We extract the contents of the secrets and store them in local variables
MYSQL_PASSWORD=$(cat /run/secrets/db_password)
WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)
WP_USER_PASSWORD=$(cat /run/secrets/wp_user_password)

# folder required for php-fpm
mkdir -p /run/php

# create web directory
mkdir -p /var/www/html

# download WP-CLI 
if [ ! -f /usr/local/bin/wp ]; then
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp
fi

# Let's see what's happening
echo "Intentando conectar a MariaDB en host: ${MYSQL_HOST} con usuario: ${MYSQL_USER}"

# We tested a direct connection with the client
until mariadb -h"${MYSQL_HOST}" -u"${MYSQL_USER}" -p"${MYSQL_PASSWORD}" -e "quit"; do
    echo "Esperando a MariaDB... (el servidor aún no acepta las credenciales)"
    sleep 3
done
echo "¡Conexión establecida correctamente!"

# Download WordPress and create the wp-config.php file
if [ ! -f /var/www/html/wp-config.php ]; then
    cd /var/www/html
    
    # Download the essential WordPress files
    wp core download --allow-root 
    # Create the wp-config.php file so that WordPress can connect to MariaDB (it passes the MariaDB data)
    wp config create \
        --dbname="${MYSQL_DATABASE}" \
        --dbuser="${MYSQL_USER}" \
        --dbpass="${MYSQL_PASSWORD}" \
        --dbhost="${MYSQL_HOST}" \
        --allow-root
fi

# Run internal installation and create the administrator
cd /var/www/html
# CWe check if WordPress is already installed so we don't repeat this process if you restart the container.
if ! wp core is-installed --allow-root; then
    wp core install \
		--url="https://${DOMAIN_NAME}" \
        --title="${WP_TITLE}" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --allow-root
# create the second user
    wp user create \
        "${WP_USER}" "${WP_USER_EMAIL}" \
        --user_pass="${WP_USER_PASSWORD}" \
        --role=author \
        --allow-root
fi

# permissions
chown -R www-data:www-data /var/www/html

# change php-fpm configuration
sed -i 's|listen = /run/php/php7.4-fpm.sock|listen = 0.0.0.0:9000|' /etc/php/7.4/fpm/pool.d/www.conf

# Start php-fpm in the foreground
exec php-fpm7.4 -F