#!/bin/sh

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
