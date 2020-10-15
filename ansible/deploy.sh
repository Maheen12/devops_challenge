#!/bin/bash
cd ~
git clone https://github.com/muneebq/docker-deploy.git
cd docker-deploy
cp Dockerfile webapp
cd webapp
sudo docker stop $(sudo docker ps -a -q)
sudo docker rm $(sudo docker ps -a -q)
sudo docker build -t myapp-nginx .
sudo docker run -d -it -p 8080:80 myapp-nginx
