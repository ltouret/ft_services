#!/bin/sh

## Start services &  keep container running
telegraf &
cd /usr/share/grafana
grafana-server

while true
do
	sleep 1
	if [ $(ps | grep -v grep | grep grafana | wc -l) -eq 0 ] || [ $(ps | grep -v grep | grep telegraf | wc -l) -eq 0 ]
	then
		exit
	fi
done
