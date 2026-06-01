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
mariadb -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"
mariadb -e "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
mariadb -e "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';"
mariadb -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
mariadb -e "FLUSH PRIVILEGES;"

kill -TERM "$pid"
wait "$pid" 2>/dev/null

#Arrancar MariaDB en foreground
# exec mysqld --user=mysql --datadir=/var/lib/mysql
exec mysqld --user=mysql --datadir=/var/lib/mysql --bind-address=0.0.0.0
