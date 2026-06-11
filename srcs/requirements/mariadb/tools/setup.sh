#!/bin/bash

# We extract the contents of the secrets and store them in local variables
MYSQL_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
MYSQL_PASSWORD=$(cat /run/secrets/db_password)

unset MYSQL_HOST

# Create the necessary folder for MariaDB
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

# Initialize mariadb
if [ ! -d "/var/lib/mysql/mysql" ]; then
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

# We only configure if our WordPress database does NOT exist.
if [ ! -d "/var/lib/mysql/${MYSQL_DATABASE}" ]; then

    echo "Configurando MariaDB por primera vez..."

	# Start temporary ONLY to create DB and user
	mysqld --user=mysql --datadir=/var/lib/mysql --skip-name-resolve --skip-networking &
	pid="$!"

	# Wait for it to boot using the local socket protocol (immune to IP/Host blocks)
	until mariadb-admin --protocol=SOCKET --socket=/run/mysqld/mysqld.sock ping --silent; do
        sleep 1
    done

	# Create database and user (Using Heredoc to avoid connection cuts)
	mariadb --protocol=SOCKET --socket=/run/mysqld/mysqld.sock << EOF
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF

mariadb-admin --protocol=SOCKET --socket=/run/mysqld/mysqld.sock -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown
wait "$pid" 2>/dev/null

	echo "¡Configuración inicial completada!"
else
    echo "La base de datos ya existe en el volumen. Saltando configuración."
fi

# Start MariaDB in foreground
exec mysqld --user=mysql --datadir=/var/lib/mysql --bind-address=0.0.0.0 --skip-name-resolve