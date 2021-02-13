#!/bin/sh

## Conf ftps 
cd /etc/vsftpd/
openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -keyout ftps.pem -out ftps.pem -subj "/C=GB/ST=London/L=London/O=Global Security/OU=IT Department/CN=example.com"
mkdir -p /home/vsftpd/admin/ 
chmod 777 /home/vsftpd/admin/
echo "admin:$(openssl passwd -1 passwd)" >> /etc/vsftpd/virtual_users
chmod 600 /etc/vsftpd/virtual_users

## Start services &  keep container running
telegraf &
vsftpd /etc/vsftpd/vsftpd.conf &

while true
do
	sleep 1
	if [ $(ps | grep -v grep | grep vsftpd | wc -l) -eq 0 ] || [ $(ps | grep -v grep | grep telegraf | wc -l) -eq 0 ]
	then
		exit
	fi
done
