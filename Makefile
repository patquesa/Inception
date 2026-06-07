all:
	mkdir -p /home/patquesa/data/mariadb
	mkdir -p /home/patquesa/data/wordpress
	docker compose -f srcs/docker-compose.yml up -d --build

down:
	docker compose -f srcs/docker-compose.yml down


clean:
	docker compose -f srcs/docker-compose.yml down -v

fclean: clean
	sudo rm -rf /home/patquesa/data/mariadb/*
	sudo rm -rf /home/patquesa/data/wordpress/*

re: fclean all

.PHONY: all down clean fclean re