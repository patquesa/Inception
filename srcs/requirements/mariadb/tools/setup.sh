#!/bin/bash

#Crear carpeta necesaria para MariaDB
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

#Inicializar la base de datos(si no existe)
if [ ! -d "/var/lib/mysql/mysql" ]; then
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

# Solo configuramos si NO existe nuestra base de datos de WordPress
if [ ! -d "/var/lib/mysql/${MYSQL_DATABASE}" ]; then

    echo "Configurando MariaDB por primera vez..."

# arrancar temporal SOLO para crear DB y user
mysqld --user=mysql --datadir=/var/lib/mysql &
pid="$!"

#esperar a que arranque
until mariadb-admin ping -h localhost --silent; do
    sleep 1
done

# crear base de datos y usuario (Usando Heredoc para evitar cortes de conexión)
    mariadb << EOF
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF

kill -TERM "$pid"
wait "$pid" 2>/dev/null

echo "¡Configuración inicial completada!"
else
    echo "La base de datos ya existe en el volumen. Saltando configuración."
fi

#Arrancar MariaDB en foreground
# exec mysqld --user=mysql --datadir=/var/lib/mysql
exec mysqld --user=mysql --datadir=/var/lib/mysql --bind-address=0.0.0.0
