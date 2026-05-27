#!/bin/bash

#Crear carpeta necesaria para MariaDB
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

#Inicializar la base de datos(si no existe)
if [ ! -d "/var/lib/mysql/mysql" ]; then
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

# arrancar temporal SOLO para crear DB y user
mysqld --user=mysql --datadir=/var/lib/mysql &
pid="$!"

#esperar a que arranque
until mariadb-admin ping -h localhost --silent; do
    sleep 1
done

#crear base de datos y usuario (AUTOMATICO)
mariadb -e "CREATE DATABASE IF NOT EXISTS wordpress;"
mariadb -e "CREATE USER IF NOT EXISTS 'wp_user'@'%' IDENTIFIED BY '1234';"
mariadb -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'wp_user'@'%';"
mariadb -e "FLUSH PRIVILEGES;"

kill -TERM "$pid"
wait "$pid" 2>/dev/null

#Arrancar MariaDB en foreground
exec mysqld
