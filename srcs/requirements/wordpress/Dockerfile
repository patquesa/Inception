FROM debian:bullseye

RUN apt update && apt install -y \
    php \
    php-fpm \
    php-mysql \
    curl \
    wget \
    tar

COPY tools/setup.sh /setup.sh
RUN chmod +x /setup.sh

ENTRYPOINT ["/setup.sh"]
