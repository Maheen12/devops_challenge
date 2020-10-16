#!/bin/bash
#!/bin/bash
cd ~
git clone https://github.com/Maheen12/devops_challenge.git
cd devops_challenge/webapp
sudo docker stop $(sudo docker ps -a -q)
sudo docker rm $(sudo docker ps -a -q)
sudo docker build -t myapp-nginx .
sudo docker run -d -it -p 8080:80 myapp-nginx
