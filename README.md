*This project has been created as part of the 42 curriculum by patquesa.*

# Inception

## Description

Inception is a system administration project from the 42 Common Core. The goal is to deploy a small infrastructure using Docker containers.

The project is composed of three services:

* **Nginx**: web server with TLS support.
* **WordPress + PHP-FPM**: content management system.
* **MariaDB**: relational database server.

Each service runs in its own container and communicates through a private Docker network.

## Project Description

Docker was chosen to provide isolation between services and to simplify deployment and maintenance. Each service is containerized independently and managed using Docker Compose.

The infrastructure is based on three main design choices:

A dedicated container for each service.
A private Docker bridge network to allow communication between containers.
Docker volumes to provide data persistence.
Docker secrets to protect sensitive information such as passwords and credentials.

This architecture improves modularity, portability and maintainability while keeping the services isolated from each other

---

## Virtual Machines vs Docker

Virtual machines emulate an entire operating system and require more resources.

Docker containers share the host kernel, start faster and consume fewer resources, making them more suitable for lightweight service-oriented architectures.

---

## Secrets vs Environment Variables

Environment variables are intended for general configuration values.

Docker secrets are used to store sensitive information such as passwords and credentials. Secrets are mounted at runtime and are not embedded inside Docker images.

Since this project handles sensitive information, the .env file and the secrets/ directory are included in the .gitignore and are not stored in the repository.

---

## Docker Network vs Host Network

Bridge networks isolate containers and provide internal DNS resolution.

Host networking shares the host network stack and reduces isolation. A bridge network was chosen to improve modularity and security.

---

## Docker Volumes vs Bind Mounts

Docker volumes are managed by Docker and are designed for persistent application data.

Bind mounts directly map host directories into containers. Volumes were chosen because they are easier to manage and provide better portability.

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
## Resources 

### Oficial Documentation

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

## AI Usage

AI tools were used as learning assistants to better understand Docker concepts, shell scripting and network configuration. They were also used to review documentation and verify compliance with the requirements of the 42 subject.

All Dockerfiles, shell scripts and configuration files were manually written, tested and validated. AI was used exclusively as a support and learning tool and not as a replacement for implementation and testing.