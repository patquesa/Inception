FROM debian:bullseye

RUN apt update && apt install -y \
    php \
    php-fpm \
    php-mysql \
    curl \
    wget \
    tar \
	mariadb-client \
    && rm -rf /var/lib/apt/lists/*

#Creamos la carpeta para que php-fpm pueda arrancar
RUN mkdir -p /run/php

COPY tools/setup.sh /setup.sh
RUN chmod +x /setup.sh

ENTRYPOINT ["/setup.sh"]
