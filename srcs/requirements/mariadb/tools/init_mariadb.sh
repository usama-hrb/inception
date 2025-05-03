#!/bin/bash

service mariadb start

sleep 3

mariadb <<< "
create database if not exists $DB_NAME ;
create user if not exists $DB_USER identified by '$DB_PASS';
grant all privileges on $DB_NAME.* to '$DB_USER'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '$ROOT_PASS';
flush privileges;
"
mariadb-admin -u root -p"$ROOT_PASS" shutdown

mariadbd-safe --port="3306" --bind="0.0.0.0" --datadir="/var/lib/mysql"