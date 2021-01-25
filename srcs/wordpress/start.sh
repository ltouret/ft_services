#!/bin/sh

## Conf Wordpress

wget https://wordpress.org/latest.tar.gz
tar xzvf latest.tar.gz
rm /www/wordpress/wp-config-sample.php
#chown -R www-data:www-data /var/www/html/wordpress
rm latest.tar.gz

## Conf ssl

#openssl req -nodes -newkey rsa:2048 -keyout server.key -out server.csr -subj "/C=GB/ST=London/L=London/O=Global Security/OU=IT Department/CN=example.com"
#openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt
#cp server.crt /etc/ssl/ssl.crt
#cp server.key /etc/ssl/ssl.key
#rm server.*

## Start services &  keep container running

/usr/sbin/php-fpm7
nginx -g 'daemon off;'
