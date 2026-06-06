all:
	mkdir -p /home/patquesa/data/mariadb
	mkdir -p /home/patquesa/data/wordpress
	docker compose -f srcs/docker-compose.yml up -d --build

down:
	docker compose -f srcs/docker-compose.yml down


clean:
	docker compose -f srcs/docker-compose.yml down -v
	sudo rm -rf /home/patquesa/data # borra la carpeta entera para una limpieza

re: clean all

.PHONY: all down clean re