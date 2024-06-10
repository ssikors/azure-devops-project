#!/bin/bash

BALANCER_PORT=$1
BACKEND_1_ADDRESS=$2
BACKEND_1_PORT=$3
BACKEND_2_ADDRESS=$4
BACKEND_2_PORT=$5

sudo apt-get update
sudo apt-get upgrade -y
sudo apt install -y nginx

cd ~/

cat << EOF > /etc/nginx/sites-enabled/lb
upstream backend {
    server $BACKEND_1_ADDRESS:$BACKEND_1_PORT;
    server $BACKEND_2_ADDRESS:$BACKEND_2_PORT;
}

server {
    listen $BALANCER_PORT;

    location / {
        proxy_pass http://backend;
        include proxy_params;
    }
}
EOF

sudo nginx -s reload
