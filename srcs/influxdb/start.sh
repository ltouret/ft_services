#!/bin/sh

## Conf influxdb
# check if following line is necessary?
#echo "auth-enabled = true" >> /etc/influxdb.conf
influxd &
sleep 5
echo "CREATE DATABASE telegraf" | influx
echo "CREATE USER admin WITH PASSWORD 'root' WITH ALL PRIVILEGES" | influx
pkill -SIGTERM influxd

## Start services &  keep container running

influxd
