SHELL := /bin/bash

up:
	docker compose --file ./srcs/docker-compose.yml up --build

down:
	docker compose --file ./srcs/docker-compose.yml down
	
exec_it:
	docker compose exec -it $(word 2, $(MAKECMDGOALS)) $(word 3, $(MAKECMDGOALS))

fclean: down
	@sudo rm -rf /home/oelharbi/data/*
	@docker rmi $$(docker images -qa) -f
	@docker system prune -a -f <<<"y"