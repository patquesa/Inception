#!/bin/bash

# Extraemos el contenido de los secretos y los guardamos en variables locales
MYSQL_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
MYSQL_PASSWORD=$(cat /run/secrets/db_password)

unset MYSQL_HOST

#Crear carpeta necesaria para MariaDB
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

#Inicializa mariadb
if [ ! -d "/var/lib/mysql/mysql" ]; then
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

# Solo configuramos si NO existe nuestra base de datos de WordPress
if [ ! -d "/var/lib/mysql/${MYSQL_DATABASE}" ]; then

    echo "Configurando MariaDB por primera vez..."

	# arrancar temporal SOLO para crear DB y user
	mysqld --user=mysql --datadir=/var/lib/mysql --skip-name-resolve --skip-networking &
	pid="$!"

	# Esperar a que arranque usando el protocolo de socket local (inmune a bloqueos de IP/Host)
	until mariadb-admin --protocol=SOCKET --socket=/run/mysqld/mysqld.sock ping --silent; do
        sleep 1
    done

	# crear base de datos y usuario (Usando Heredoc para evitar cortes de conexión)
	#mariadb --socket=/run/mysqld/mysqld.sock << EOF
	mariadb --protocol=SOCKET --socket=/run/mysqld/mysqld.sock << EOF
	CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
	CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
	GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
	ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
	FLUSH PRIVILEGES;
EOF

#mariadb-admin --socket=/run/mysqld/mysqld.sock shutdown
mariadb-admin --protocol=SOCKET --socket=/run/mysqld/mysqld.sock -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown
wait "$pid" 2>/dev/null

	echo "¡Configuración inicial completada!"
else
    echo "La base de datos ya existe en el volumen. Saltando configuración."
fi

#Arrancar MariaDB en foreground
#exec mysqld --user=mysql --datadir=/var/lib/mysql --bind-address=0.0.0.0
# Tu línea final en MariaDB setup.sh debe ser solo:
exec mysqld --user=mysql --datadir=/var/lib/mysql --bind-address=0.0.0.0 --skip-name-resolve