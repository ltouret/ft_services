#!/bin/sh

## Conf influxdb
influxd &
sleep 5
echo "CREATE DATABASE telegraf" | influx
echo "CREATE USER admin WITH PASSWORD 'root' WITH ALL PRIVILEGES" | influx

## Start services &  keep container running
telegraf &

while true
do
	sleep 1
	if [ $(ps | grep -v grep | grep influxd | wc -l) -eq 0 ] || [ $(ps | grep -v grep | grep telegraf | wc -l) -eq 0 ]
	then
		exit
	fi
done
