#!/bin/bash

# carpeta necesaria para php-fpm
mkdir -p /run/php

# crear directorio web
mkdir -p /var/www/html

# descargar WP-CLI (si no lo pusiste en el Dockerfile, lo instalamos aquí)
if [ ! -f /usr/local/bin/wp ]; then
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp
fi

# 3. Descargar archivos de la web y configurar conexión a la BD
if [ ! -f /var/www/html/wp-config.php ]; then
    cd /var/www/html
    
    wp core download --allow-root

    wp config create \
        --dbname="${MYSQL_DATABASE}" \
        --dbuser="${MYSQL_USER}" \
        --dbpass="${MYSQL_PASSWORD}" \
        --dbhost="${MYSQL_HOST}" \
        --allow-root
fi

# esperar MariaDB
until mariadb -h"${MYSQL_HOST}" -u"${MYSQL_USER}" -p"${MYSQL_PASSWORD}" -e "SELECT 1" 2>/dev/null; do
    echo "Waiting for MariaDB..."
    sleep 2
done

# Ejecutar instalación interna y crear los dos usuarios del .env
cd /var/www/html
if ! wp core is-installed --allow-root; then
    wp core install \
        --url="${DOMAIN_NAME}" \
        --title="${WP_TITLE}" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --allow-root

    wp user create \
        "${WP_USER}" "${WP_USER_EMAIL}" \
        --user_pass="${WP_USER_PASSWORD}" \
        --role=author \
        --allow-root
fi

#permisos
chown -R www-data:www-data /var/www/html

# cambiar configuración php-fpm
sed -i 's|listen = /run/php/php7.4-fpm.sock|listen = 0.0.0.0:9000|' /etc/php/7.4/fpm/pool.d/www.conf

#arrancar php-fpm
exec php-fpm7.4 -F