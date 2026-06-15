# Developer Documentation

## Overview

Inception is a containerized infrastructure composed of three services:

* Nginx
* WordPress + PHP-FPM
* MariaDB

Each service runs inside its own container and communicates through a private Docker bridge network.

---

## Architecture

```text
Client
    ↓
Nginx
    ↓
PHP-FPM
    ↓
WordPress
    ↓
wp-config.php
    ↓
MariaDB (mysqld)
    ↓
/var/lib/mysql
```

---

## Docker

The project is orchestrated using Docker Compose.

Each service has its own:

* Dockerfile
* setup.sh script
* Container

```text
Dockerfile
    ↓
Image
    ↓
Container
    ↓
setup.sh
    ↓
Main process
```

---

## Container Management

Display running containers:

```bash
docker ps
```

Display Docker Compose containers:

```bash
docker compose -f srcs/docker-compose.yml ps
```

Display service logs:

```bash
docker logs nginx
docker logs wordpress
docker logs mariadb
```

Stop the containers:

```bash
docker compose -f srcs/docker-compose.yml down
```

---

## Volume Management

List Docker volumes:

```bash
docker volume ls
```

Inspect a volume:

```bash
docker volume inspect <volume_name>
```

---

## Data Persistence

Project data is stored on the host machine and mounted inside the containers through Docker volumes.

WordPress files are stored in:

```text
/home/patquesa/data/wordpress
```

MariaDB data is stored in:

```text
/home/patquesa/data/mysql
```

Inside the containers, these paths are mounted as:

```text
/var/www/html
/var/lib/mysql
```

This ensures that rebuilding containers or restarting the virtual machine does not erase the website files or the database.

---

## Nginx

Nginx is the web server.

Responsibilities:

* Handle HTTPS connections.
* Use TLS certificates.
* Listen on port 443.
* Forward PHP requests to PHP-FPM.

Example:

```nginx
fastcgi_pass wordpress:9000;
```

Nginx acts as a reverse proxy between the client and PHP-FPM.

---

## PHP-FPM

PHP-FPM (PHP FastCGI Process Manager) is responsible for executing PHP code.

Responsibilities:

* Receive requests from Nginx.
* Execute WordPress.
* Return generated HTML.

By default, PHP-FPM uses a Unix socket:

```text
/run/php/php7.4-fpm.sock
```

Since Nginx and WordPress are located in different containers, PHP-FPM is configured to listen on:

```text
0.0.0.0:9000
```

allowing communication through TCP.

---

## WordPress

WordPress is a CMS written in PHP.

It is executed by PHP-FPM and uses MariaDB to store:

* Users
* Posts
* Comments
* Site configuration

The main configuration file is:

```text
wp-config.php
```

which contains:

* Database name
* Database user
* Database password
* Database host

---

## MariaDB

MariaDB is a relational database server.

The server executable is:

```text
mysqld
```

Responsibilities:

* Store data.
* Execute SQL queries.
* Handle client connections.

Data are stored inside:

```text
/var/lib/mysql
```

The MariaDB client is:

```text
mariadb
```

which sends SQL commands to the server.

---

## Setup Scripts

Each service uses a setup.sh script.

Responsibilities:

* Initialize the service.
* Perform configuration tasks.
* Start the real service.

Examples:

MariaDB:

```bash
exec mysqld
```

WordPress:

```bash
exec php-fpm7.4 -F
```

Nginx:

```bash
exec nginx -g "daemon off;"
```

The exec command replaces the shell process and makes the service the main process of the container.

---

## Networks

Docker creates a private bridge network.

Communication between containers uses:

* TCP
* DNS names
* Ports

Examples:

```text
wordpress:9000
mariadb:3306
```

Docker automatically provides DNS resolution using service names.

---

## Volumes

Volumes provide data persistence.

MariaDB:

```text
/var/lib/mysql
```

WordPress:

```text
/var/www/html
```

Therefore, restarting containers does not erase data.

---

## Environment Variables

Configuration values are stored in:

```text
srcs/.env
```

Examples:

```text
MYSQL_DATABASE
MYSQL_USER
MYSQL_HOST
WP_TITLE
DOMAIN_NAME
```

---

## Secrets

Sensitive information is stored using Docker secrets.

Examples:

```text
db_password
db_root_password
wp_admin_password
```

Secrets are mounted inside:

```text
/run/secrets/
```

and read by the setup scripts.

---

## Communication Flow

```text
User
↓
Nginx
↓
PHP-FPM
↓
WordPress
↓
wp-config.php
↓
MariaDB
↓
/var/lib/mysql

MariaDB returns data

↓
WordPress generates HTML

↓
PHP-FPM

↓
Nginx

↓
User
```

---

## References

### Official Documentation

* Docker Documentation
  https://docs.docker.com/
* Docker Compose Documentation
  https://docs.docker.com/compose/
* Nginx Documentation
  https://nginx.org/en/docs/
* PHP-FPM Documentation
  https://www.php.net/manual/en/install.fpm.php
* MariaDB Documentation
  https://mariadb.com/kb/en/documentation/
* WordPress Documentation
  https://developer.wordpress.org/

### Learning Resources

* HolaMundo – *Aprende Docker ahora! Curso completo gratis desde cero!*
  https://www.youtube.com/watch?v=4Dko5W96WHg

* 42Fran-byte – *Inception 42*
  https://www.youtube.com/watch?v=VfTQTgJo_fE
