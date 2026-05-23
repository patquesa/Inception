#creo primera imagen
#FROM debian
#CMD ["echo", "Hola desde mi primera imagen Docker"]

#instalo un programa curl
#FROM debian
#RUN apt update
#RUN apt install -y curl

#CMD ["curl", "--version"]

#aprendo a copiar desde un archivo a la imagen
#FROM debian
#COPY mensaje.txt /mensaje.txt

#CMD ["cat", "/mensaje.txt"]

#crear /app (si no existe) y trabaja dentro de esa carpeta (copia mensaje.txt)
#FROM debian
#WORKDIR /app

#COPY mensaje.txt .
#solo se puede poner un comando, si hay dos, se ejecuta el segundo
#CMD ["cat", "mensaje.txt"]
#CMD ["pwd"]

FROM debian

RUN apt update
RUN apt install -y nginx

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]