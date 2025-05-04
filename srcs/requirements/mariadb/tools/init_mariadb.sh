#!/bin/bash

# Start MariaDB tmp for initialization
service mariadb start

sleep 3

mariadb <<< "
create database if not exists $DB_NAME ;
create user if not exists $DB_USER identified by '$DB_PASS';
grant all privileges on $DB_NAME.* to '$DB_USER'@'%';
alter user 'root'@'localhost' identified by '$ROOT_PASS';
flush privileges;
"

# Shut down the tmp server
mariadb-admin -u root -p"$ROOT_PASS" shutdown

# Start MariaDB in foreground with safe wrapper
mariadbd-safe --port="3306" --bind="0.0.0.0" --datadir="/var/lib/mysql"