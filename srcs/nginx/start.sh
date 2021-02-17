#!/bin/sh

## Conf ssl
openssl req -nodes -newkey rsa:2048 -keyout server.key -out server.csr -subj "/C=GB/ST=London/L=London/O=Global Security/OU=IT Department/CN=example.com"
openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt
cp server.crt /etc/ssl/ssl.crt
cp server.key /etc/ssl/ssl.key
rm server.*

## Start services &  keep container running
telegraf &
nginx

while true
do
	sleep 1
	if [ $(ps | grep -v grep | grep nginx | wc -l) -eq 0 ] || [ $(ps | grep -v grep | grep telegraf | wc -l) -eq 0 ]
	then
		exit
	fi
done
