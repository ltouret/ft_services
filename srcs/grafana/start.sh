#!/bin/sh

## Print user & pass
echo "
	Grafana
	User: admin
	Passwd: cursus42 
"

## Start services &  keep container running

cd /usr/share/grafana
grafana-server
