#!/bin/sh

## Conf mysql
mkdir -p /var/lib/mysql /run/mysqld

# install and start services
mysql_install_db -u root
mysqld -u root &
sleep 5

if ! mysql -u root -e 'USE wordpress'; then
	mysql -u root -e "CREATE DATABASE wordpress DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;"
fi

mysql -u root -e "CREATE USER 'admin'@'%' IDENTIFIED BY 'passwd';GRANT ALL PRIVILEGES ON *.* TO 'admin'@'%' WITH GRANT OPTION;USE wordpress;FLUSH PRIVILEGES;SHUTDOWN;"

## Start services &  keep container running
telegraf &
mysqld -u root &

while true
do
	sleep 1
	if [ $(ps | grep -v grep | grep mysqld | wc -l) -eq 0 ] || [ $(ps | grep -v grep | grep telegraf | wc -l) -eq 0 ]
	then
		exit
	fi
done
