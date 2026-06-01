FROM debian:bullseye

RUN apt update && apt install -y \
    mariadb-server \
    && rm -rf /var/lib/apt/lists/*

EXPOSE 3306

COPY tools/setup.sh /setup.sh

RUN chmod +x /setup.sh

ENTRYPOINT ["/setup.sh"]