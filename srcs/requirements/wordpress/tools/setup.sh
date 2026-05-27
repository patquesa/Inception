#!/bin/bash

# carpeta necesaria para php-fpm
mkdir -p /run/php

# crear directorio web
mkdir -p /var/www/html

# descargar WordPress
if [ ! -f /var/www/html/wp-config.php ]; then
	curl -o /tmp/wordpress.tar.gz https://wordpress.org/latest.tar.gz

	#descomprimir WordPress
	tar -xzf /tmp/wordpress.tar.gz -C /var/www/html --strip-components=1

	# crear wp-config.php
	cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php

	#configurar WordPress
	sed -i "s/database_name_here/${MYSQL_DATABASE}/" /var/www/html/wp-config.php
    sed -i "s/username_here/${MYSQL_USER}/" /var/www/html/wp-config.php
    sed -i "s/password_here/${MYSQL_PASSWORD}/" /var/www/html/wp-config.php
    sed -i "s/localhost/${MYSQL_HOST}/" /var/www/html/wp-config.php

	rm -f /tmp/wordpress.tar.gz
fi

# esperar MariaDB
until mariadb -h"${MYSQL_HOST}" -u"${MYSQL_USER}" -p"${MYSQL_PASSWORD}" -e "SELECT 1" 2>/dev/null; do
    echo "Waiting for MariaDB..."
    sleep 2
done

#permisos
chown -R www-data:www-data /var/www/html

#arrancar php-fpm
exec php-fpm7.4 -F