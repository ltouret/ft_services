#!/bin/sh

## Conf ssl

openssl req -nodes -newkey rsa:2048 -keyout server.key -out server.csr -subj "/C=GB/ST=London/L=London/O=Global Security/OU=IT Department/CN=example.com"
openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt
cp server.crt /etc/ssl/ssl.crt
cp server.key /etc/ssl/ssl.key
rm server.*

## Start services &  keep container running

nginx -g 'daemon off;'
