# Usamos Debian Bullseye como sistema operativo base
FROM debian:bullseye

# Actualizamos el sistema e instalamos Nginx
RUN apt-get update && apt-get install -y nginx

# Borramos la configuración por defecto que trae Nginx para que no choque con la nuestra
RUN rm -rf /etc/nginx/sites-available/default \
    && rm -rf /etc/nginx/sites-enabled/default

# Copiamos TU archivo de configuración al sitio correcto dentro del contenedor
COPY ./config/nginx.conf /etc/nginx/sites-available/default

# Creamos un enlace simbólico para activar la configuración
RUN ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

# Obligamos a Nginx a ejecutarse en primer plano para que el contenedor no se apague
CMD ["nginx", "-g", "daemon off;"]