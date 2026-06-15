# Inception

*This project has been created as part of the 42 curriculum by patquesa*

## Description

Inception is a system administration project from the 42 Common Core. The goal is to deploy a small infrastructure using Docker containers.

The project is composed of three services:

* **Nginx**: web server with TLS support.
* **WordPress + PHP-FPM**: content management system.
* **MariaDB**: relational database server.

Each service runs in its own container and communicates through a private Docker network.

---

## Project Structure

```text
.
├── Makefile
└── srcs
    ├── docker-compose.yml
    ├── .env
    └── requirements
        ├── mariadb
        ├── nginx
        └── wordpress
```

---

## Services

### Nginx

* HTTPS enabled
* TLS certificate
* Port 443 exposed

### WordPress

* PHP-FPM
* WordPress installation
* Persistent storage

### MariaDB

* Relational database
* Persistent storage

---

## Build and Start

```bash
make
```

or

```bash
docker compose -f srcs/docker-compose.yml up -d --build
```

---

## Stop Containers

```bash
make down
```

---

## Remove Containers, Images and Volumes

```bash
make fclean
```

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
MariaDB
```
## Resources Documentation

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

## Learning Resources

* HolaMundo – *Aprende Docker ahora! Curso completo gratis desde cero!*
  https://www.youtube.com/watch?v=4Dko5W96WHg

* 42Fran-byte – *Inception 42*
  https://www.youtube.com/watch?v=VfTQTgJo_fE

## AI Usage

This project was developed with the assistance of AI tools. AI was used to better understand Docker network configurations, troubleshoot SSH connectivity issues within the virtual machine, and verify that the project structure and documentation met the requirements of the 42 curriculum. All configuration files and scripts were manually reviewed to ensure accuracy and compliance with the subject.