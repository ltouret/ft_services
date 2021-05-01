#!/bin/sh

## Conf Wordpress
wget https://wordpress.org/latest.tar.gz
tar xzvf latest.tar.gz
rm latest.tar.gz

## Conf Wordpress users
wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
mv wp-cli.phar /usr/bin/wp-cli && chmod 777 /usr/bin/wp-cli
wp-cli --allow-root --path=/www/wordpress config create --dbname=wordpress --dbuser=admin --dbpass=passwd --dbhost=mysql
wp-cli --allow-root --path=/www/wordpress core install  --title=wordpress --admin_user=admin --admin_password=passwd --admin_email=test@test.com --url=minikube_ip:5050
wp-cli --allow-root --path=/www/wordpress user create user1 user1@test.com --role=editor --user_pass=passwd
wp-cli --allow-root --path=/www/wordpress user create user2 user2@test.com --role=editor --user_pass=passwd
wp-cli --allow-root --path=/www/wordpress user create user3 user3@test.com --role=editor --user_pass=passwd

## Start services &  keep container running
telegraf &
php-fpm7
nginx

while true
do
	sleep 1
	if [ $(ps | grep -v grep | grep nginx | wc -l) -eq 0 ] || [ $(ps | grep -v grep | grep php-fpm | wc -l) -eq 0 ] || [ $(ps | grep -v grep | grep telegraf | wc -l) -eq 0 ]
	then
		exit
	fi
done
