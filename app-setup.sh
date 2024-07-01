#!/bin/bash
sudo apt update -y
sudo apt upgrade -y
cd /var/tmp/
wget https://dl.google.com/go/go1.22.4.linux-amd64.tar.gz
sudo rm -rf /usr/local/go 
sudo tar -C /usr/local -xzf go1.22.4.linux-amd64.tar.gz

git clone https://github.com/infezek/app-alb-terraform.git alb-app
cd /var/tmp/alb-app
GOCACHE=/tmp/gocache GOOS=linux GOARCH=amd64 /usr/local/go/bin/go build -o /home/ubuntu/serve -buildvcs=false

sudo iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-ports 8080
sudo cp alb-http.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable alb-http
sudo systemctl restart alb-http