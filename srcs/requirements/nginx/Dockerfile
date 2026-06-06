# Usamos Debian Bullseye como sistema operativo base
FROM debian:bullseye

# Actualizamos el sistema e instalamos Nginx
RUN apt-get update && apt-get install -y \
	nginx \
	openssl 

# Borramos la configuración por defecto que trae Nginx para que no choque con la nuestra
RUN rm -rf /etc/nginx/sites-available/default \
    && rm -rf /etc/nginx/sites-enabled/default

# CREAMOS LAS LLAVES TLS (Lo que nos faltaba)
# Creamos la carpeta de seguridad y fabricamos el certificado (.crt) y la llave (.key)
RUN mkdir -p /etc/nginx/ssl && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/inception.key \
    -out /etc/nginx/ssl/inception.crt \
    -subj "/C=ES/ST=Andalucia/L=Malaga/O=42/OU=42Malaga/CN=patquesa.42.fr"

# Copiamos TU archivo de configuración al sitio correcto dentro del contenedor
COPY ./conf/nginx.conf /etc/nginx/sites-available/default

# Creamos un enlace simbólico para activar la configuración
RUN ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

# Obligamos a Nginx a ejecutarse en primer plano para que el contenedor no se apague
CMD ["nginx", "-g", "daemon off;"]