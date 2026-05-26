#!/bin/bash

# carpeta necesaria para php-fpm
mkdir -p /run/php

# crear directorio web
mkdir -p /var/www/html

# descargar WordPress
curl -o wordpress.tar.gz https://wordpress.org/latest.tar.gz
tar -xzf wordpress.tar.gz -C /var/www/html --strip-components=1

#permisos
chown -R www-data:www-data /var/www/html

exec php-fpm7.4 -F