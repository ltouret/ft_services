#!/bin/sh

## Conf ftps 

cd /etc/vsftpd/
openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -keyout ftps.pem -out ftps.pem -subj "/C=GB/ST=London/L=London/O=Global Security/OU=IT Department/CN=example.com"
mkdir -p /home/vsftpd/admin/ 
chmod 777 /home/vsftpd/admin/
echo "admin:$(openssl passwd -1 root)" >> /etc/vsftpd/virtual_users
chmod 600 /etc/vsftpd/virtual_users

## Print user & pass
echo "
	Ftps server
	User: admin
	Passwd: root
"

## Start services &  keep container running

vsftpd /etc/vsftpd/vsftpd.conf
