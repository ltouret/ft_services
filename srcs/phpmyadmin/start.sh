#!/bin/sh

## Conf phpMyAdmin

wget https://files.phpmyadmin.net/phpMyAdmin/4.9.5/phpMyAdmin-4.9.5-all-languages.tar.gz 
tar xzvf phpMyAdmin-4.9.5-all-languages.tar.gz
mv phpMyAdmin-4.9.5-all-languages/* /www/phpmyadmin/
rm phpmyadmin/config.sample.inc.php
rm -rf phpMyAdmin-4.9.5-all-languages.tar.gz phpMyAdmin-4.9.5-all-languages

## Start services &  keep container running

/usr/sbin/php-fpm7
nginx -g 'daemon off;'
