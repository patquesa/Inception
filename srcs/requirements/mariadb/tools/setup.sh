#!/bin/bash

#Crear carpeta necesaria para MariaDB
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

#Inicializar la base de datos(si no existe)
mysql_install_db --user=mysql --datadir=/var/lib/mysql

#Arrancar MariaDB en foreground
exec mysqld
