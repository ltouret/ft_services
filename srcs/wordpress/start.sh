#!/bin/sh

## Conf Wordpress
wget https://wordpress.org/latest.tar.gz
tar xzvf latest.tar.gz
rm /www/wordpress/wp-config-sample.php
rm latest.tar.gz

## Start services &  keep container running
telegraf &
php-fpm7
nginx -g 'daemon off;'
