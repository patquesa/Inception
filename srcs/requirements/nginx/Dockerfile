# We use Debian Bullseye as our base operating system.
FROM debian:bullseye

# We updated the system and installed Nginx
RUN apt-get update && apt-get install -y \
	nginx \
	openssl 

# We deleted the default configuration that comes with Nginx so that it doesn't conflict with ours.
RUN rm -rf /etc/nginx/sites-available/default \
    && rm -rf /etc/nginx/sites-enabled/default

# We created the security folder and generated the certificate (.crt) and the key (.key).
RUN mkdir -p /etc/nginx/ssl && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/inception.key \
    -out /etc/nginx/ssl/inception.crt \
    -subj "/C=ES/ST=Andalucia/L=Malaga/O=42/OU=42Malaga/CN=patquesa.42.fr"

# We copied YOUR configuration file to the correct location inside the container
COPY ./conf/nginx.conf /etc/nginx/sites-available/default

# We created a symbolic link to activate the configuration
RUN ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

# We force Nginx to run in the foreground so that the container doesn't shut down.
CMD ["nginx", "-g", "daemon off;"]