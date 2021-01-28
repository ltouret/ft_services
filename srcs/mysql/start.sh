#!/bin/sh

## Conf mysql

mkdir -p /var/lib/mysql /run/mysqld

# install and start services
mysql_install_db -u root
/usr/bin/mysqld -u root --console &
sleep 5

mysql -u root -e "CREATE DATABASE wordpress DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;"
mysql -u root -e "GRANT ALL ON wordpress.* TO 'wordpress_user'@'localhost' IDENTIFIED BY 'password';"
mysql -u root -e "FLUSH PRIVILEGES"

## Start services &  keep container running

sleep infinity
