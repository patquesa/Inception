FROM debian
#creo primera imagen
#CMD ["echo", "Hola desde mi primera imagen Docker"]

#instalo un programa curl
#RUN apt update
#RUN apt install -y curl

#CMD ["curl", "--version"]

#aprendo a copiar desde un archivo a la imagen
#COPY mensaje.txt /mensaje.txt

#CMD ["cat", "/mensaje.txt"]

#crear /app (si no existe) y trabaja dentro de esa carpeta (copia mensaje.txt)
WORKDIR /app

COPY mensaje.txt .

CMD ["cat", "mensaje.txt"]

CMD ["pwd"]