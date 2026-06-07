#!/bin/bash

# Extraemos el contenido de los secretos y los guardamos en variables locales
MYSQL_PASSWORD=$(cat /run/secrets/db_password)
WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)
WP_USER_PASSWORD=$(cat /run/secrets/wp_user_password)

# carpeta necesaria para php-fpm
mkdir -p /run/php

# crear directorio web
mkdir -p /var/www/html

# descargar WP-CLI 
if [ ! -f /usr/local/bin/wp ]; then
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp
fi

# esperar MariaDB
until mariadb -h"${MYSQL_HOST}" -u"${MYSQL_USER}" -p"${MYSQL_PASSWORD}" -e "SELECT 1" 2>/dev/null; do
    echo "Waiting for MariaDB..."
    sleep 2
done

# Descargar WordPress y crear el archivo wp-config.php
if [ ! -f /var/www/html/wp-config.php ]; then
    cd /var/www/html
    
    wp core download --allow-root # Descarga los archivos limpios de WordPress
# Crea el archivo wp-config.php para que wordpress se pueda conectar a mariadb (le pasa los datos de mariadb)
    wp config create \
        --dbname="${MYSQL_DATABASE}" \
        --dbuser="${MYSQL_USER}" \
        --dbpass="${MYSQL_PASSWORD}" \
        --dbhost="${MYSQL_HOST}" \
        --allow-root
fi

# Ejecutar instalación interna y crear el administrador
cd /var/www/html
# Comprobamos si WordPress ya está instalado para no repetir este proceso si reinicias el contenedor
if ! wp core is-installed --allow-root; then
    wp core install \
        --url="${DOMAIN_NAME}" \
		#--url="https://${DOMAIN_NAME}" COMPROBAR
        --title="${WP_TITLE}" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --allow-root
# crea el segundo usuario
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

#arrancar php-fpm en primer plano
exec php-fpm7.4 -F