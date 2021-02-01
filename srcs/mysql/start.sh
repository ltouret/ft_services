#!/bin/sh

## Conf mysql

mkdir -p /var/lib/mysql /run/mysqld

# install and start services
mysql_install_db -u root
mysqld -u root &
sleep 5

if ! mysql -u root -e 'USE wordpress'; then
	mysql -u root -e "CREATE DATABASE wordpress DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;"
	mysql -u root wordpress < /wordpress-tmp.sql
fi

# check this line, maybe doesnt work?
mysql -u root -e "GRANT ALL ON wordpress.* TO 'wordpress_user'@'localhost' IDENTIFIED BY 'password';"
mysql -u root -e "FLUSH PRIVILEGES;SHUTDOWN"

## Start services &  keep container running

mysqld -u root
