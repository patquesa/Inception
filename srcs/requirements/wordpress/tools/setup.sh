#!/bin/bash

# carpeta necesaria para php-fpm
mkdir -p /run/php

# crear directorio web
mkdir -p /var/www/html

# descargar WordPress
curl -o wordpress.tar.gz https://wordpress.org/latest.tar.gz

#descomprimir WordPress
tar -xzf wordpress.tar.gz -C /var/www/html --strip-components=1

# crear wp-config.php
cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php

#configurar WordPress
sed -i "s/database_name_here/wordpress/" /var/www/html/wp-config.php
sed -i "s/username_here/wp_user/" /var/www/html/wp-config.php
sed -i "s/password_here/1234/" /var/www/html/wp-config.php
sed -i "s/localhost/mariadb/" /var/www/html/wp-config.php

# esperar MariaDB
until mariadb -h mariadb -u wp_user -p1234 -e "SELECT 1" 2>/dev/null; do
    echo "Waiting for MariaDB..."
    sleep 2
done

#permisos
chown -R www-data:www-data /var/www/html

#arrancar php-fpm
exec php-fpm7.4 -F