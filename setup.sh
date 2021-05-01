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
if [ "$MINIKUBE_IP" = "127.0.0.1" ]
then
	MINIKUBE_IP="172.17.0.2"
fi

echo "
MINIKUBE_IP = $MINIKUBE_IP"

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

sed -i.bak "s/minikube_ip/$MINIKUBE_IP/g" srcs/ftps/vsftpd.conf
sed -i.bak "s/minikube_ip/$MINIKUBE_IP/g" srcs/wordpress/start.sh
sed -i.bak "s/minikube_ip/$MINIKUBE_IP/g" srcs/metallb/metallb.yaml

for service in phpmyadmin influxdb mysql grafana wordpress ftps nginx 
do
	docker build -t ${service}_custom srcs/$service/
	kubectl apply -f srcs/$service/$service.yaml
done
kubectl apply -f srcs/metallb/metallb.yaml

mv srcs/ftps/vsftpd.conf.bak srcs/ftps/vsftpd.conf
mv srcs/wordpress/start.sh.bak srcs/wordpress/start.sh
mv srcs/metallb/metallb.yaml.bak srcs/metallb/metallb.yaml

echo "
Nginx : http://${MINIKUBE_IP} ou https://${MINIKUBE_IP}
"
echo "PhpMyAdmin : http://${MINIKUBE_IP}:5000 ou http://${MINIKUBE_IP}/phpmyadmin
user: admin
password: passwd
"
echo "Wordpress : http://${MINIKUBE_IP}:5050 ou http://${MINIKUBE_IP}/wordpress
"
echo "Wordpress : 
users: user1, user2, user3
password: passwd
"
echo "Grafana : http://${MINIKUBE_IP}:3000
user: admin
password: passwd"

echo "
# starting dashboard ...
"

minikube dashboard
