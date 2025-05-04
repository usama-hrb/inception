FROM debian:bullseye

RUN apt-get update && apt-get upgrade -y  \
	&& apt-get install mariadb-client mariadb-server -y 

COPY ./tools/init_mariadb.sh .

RUN chmod +x init_mariadb.sh

ENTRYPOINT ["./init_mariadb.sh"]