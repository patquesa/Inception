# Inception

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
