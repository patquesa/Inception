# User Guide

## Introduction

This document explains how to use the Inception project.

The infrastructure consists of three services:

* Nginx
* WordPress
* MariaDB

---

# Requirements

The following tools must be installed:

* Docker
* Docker Compose
* Make

---

# Build and Start

To build and start the containers:

```bash
make
```

or

```bash
docker compose -f srcs/docker-compose.yml up -d --build
```

---

# Access the Website

Public Site: Open your browser and go to:

```text
https://<DOMAIN_NAME>
```

Example:

```text
https://patquesa.42.fr
```
Admin Panel: Go to:

```text
https://<DOMAIN_NAME>/wp-admin
```

---

# Available Users & Security

## Administrator

The administrator account is created automatically during the WordPress installation.

It has full privileges over the website.

---

## Standard User

A second user account is also created automatically.

This account has author privileges.

---

## Security

For security, the administrator username does not include "admin". Credentials are managed via the .env file in the srcs/ directory and must be kept secure.

---

# Useful Commands

## Start the project

```bash
make
```

---

## Stop containers

```bash
make down
```

---

## Restart containers

```bash
make re
```

---

## Remove containers, images and volumes

```bash
make fclean
```

---

# Persistent Data

The following data are preserved through Docker volumes:

* WordPress files.
* MariaDB database.

Therefore, restarting the containers does not erase the website or database contents.

---

# HTTPS

The website is available through HTTPS.

Nginx handles TLS encryption and listens on port 443.

---

# Troubleshooting

## Check running containers

```bash
docker ps
```

---

## Display logs

```bash
docker logs <container_name>
```

Examples:

```bash
docker logs nginx
docker logs wordpress
docker logs mariadb
```

---

## Stop all containers

```bash
docker compose -f srcs/docker-compose.yml down
```
## Verify volumes

```bash
docker volume inspect srcs_mariadb_data
```