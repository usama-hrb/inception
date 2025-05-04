#!/bin/bash

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

chmod +x wp-cli.phar

mv wp-cli.phar /usr/sbin/wp



cd /var/www/wordpress

wp core download --allow-root

sleep 5

wp core config --dbname=$DB_NAME --dbuser=$DB_USER --dbpass=$DB_PASS --dbhost=mariadb:3306 --allow-root

wp core install --url=$DOMAIN_NAME --title="Inception" --admin_user=$WP_ADMIN_USER --admin_password=$WP_ADMIN_PASS --admin_email=$WP_ADMIN_EMAIL  --allow-root


wp user create $WP_USER $WP_USER_MAIL --role=$WP_ROLE --allow-root

chmod -R 777 /var/www

chown -R www-data:www-data /var/www/wordpress


sed -i 's#listen = /run/php/php7.4-fpm.sock#listen = 0.0.0.0:9000#' /etc/php/7.4/fpm/pool.d/www.conf

/usr/sbin/php-fpm7.4 -F