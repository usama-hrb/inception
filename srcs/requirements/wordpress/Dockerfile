FROM debian:bullseye

RUN apt update && apt upgrade -y && \
	apt install php php-fpm php-mysqli\ 
	curl -y


RUN mkdir -p /var/www/wordpress && chmod -R 777 /var/www

COPY ./tools/init_wp.sh .

RUN chmod +x init_wp.sh

RUN mkdir -p /run/php/ 

RUN	sed -i 's#listen = /run/php/php7.4-fpm.sock#listen = 0.0.0.0:9000#' \
	/etc/php/7.4/fpm/pool.d/www.conf

ENTRYPOINT [ "./init_wp.sh" ]