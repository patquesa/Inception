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

# We created the folder so that php-fpm could start.
RUN mkdir -p /run/php

WORKDIR /var/www/html

COPY tools/setup.sh /setup.sh
RUN chmod +x /setup.sh

ENTRYPOINT ["/setup.sh"]
