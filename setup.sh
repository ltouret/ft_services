#!/bin/bash

set -e

panic ()
{
	echo "Failed !"
	exit 1
}

echo "
# Starting minikube ...
"
minikube status > /dev/null \
	&& echo Reusing current instance. \
	|| minikube start --driver docker \
	|| panic

MINIKUBE_IP=$(minikube ip)
if [ "MINIKUBE_IP" = "127.0.0.1"]
then
	MINIKUBE_IP="172.17.0.2"
fi

eval $(minikube docker-env)

echo "

# MetalLB installation ...
"

kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.5/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.5/manifests/metallb.yaml
envsubst < srcs/metallb/metallb.yaml | kubectl apply -f - || panic
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"

echo "

# Building containers ...
"

for service in influxdb nginx phpmyadmin mysql ftps grafana wordpress
do
	docker build -t ${service}_custom srcs/$service/
	sed -i.bak "s/minikube_ip/$MINIKUBE_IP/g" srcs/$service/$service.yaml
	mv srcs/$service/$service.yaml.bak srcs/$service/$service.yaml
	kubectl apply -f srcs/$service/$service.yaml
done

sed -i.bak "s/minikube_ip/$MINIKUBE_IP/g" srcs/metallb/metallb.yaml
kubectl apply -f srcs/metallb/metallb.yaml
mv srcs/metallb/metallb.yaml.bak srcs/metallb/metallb.yaml
