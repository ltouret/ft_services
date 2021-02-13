#!/bin/sh

## Conf phpMyAdmin
wget https://files.phpmyadmin.net/phpMyAdmin/4.9.5/phpMyAdmin-4.9.5-all-languages.tar.gz 
tar xzvf phpMyAdmin-4.9.5-all-languages.tar.gz
mv phpMyAdmin-4.9.5-all-languages/* /www/phpmyadmin/
rm phpmyadmin/config.sample.inc.php
rm -rf phpMyAdmin-4.9.5-all-languages.tar.gz phpMyAdmin-4.9.5-all-languages

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
