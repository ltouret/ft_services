#!/bin/sh

## Print user & pass
echo "
	Grafana
	User: admin
	Passwd: passwd 
"

## Start services &  keep container running
telegraf &
cd /usr/share/grafana
grafana-server
