#!/bin/sh

## Conf influxdb
influxd &
sleep 5
echo "CREATE DATABASE telegraf" | influx
echo "CREATE USER admin WITH PASSWORD 'root' WITH ALL PRIVILEGES" | influx
pkill -SIGTERM influxd

## Start services &  keep container running
telegraf &
influxd
