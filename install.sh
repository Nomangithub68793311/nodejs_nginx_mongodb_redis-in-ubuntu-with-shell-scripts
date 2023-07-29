#! /bin/bash

####################

# author : Rana Ahamed
# date : 29/07/2023
# using node mongo nginx
# trying to deploy a nodejs API app through shell scripting


###################
set -x
set -e 
set -o pipefail

sudo apt-get update
# sudo apt-get install npm -y

sudo apt install curl 
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y Node.js 
# npm i -g n
# n install lts
apt install mongodb -y
sudo systemctl start mongodb
# sudo systemctl status mongodb

#to check api an dport of monbgodb...

mongo --eval 'db.runCommand({ connectionStatus: 1 })'
sudo apt-get install nginx -y
ip=$(wget -qO- http://ipecho.net/plain | xargs echo)
echo -e "server {listen 80;\n\tlisten [::]:80;\n\tserver_name $ip;\n\tlocation / {\n\tproxy_pass http://localhost:5000;\n\tproxy_http_version 1.1;\n\t proxy_set_header Upgrade $"http_upgrade";\n\tproxy_set_header Connection 'upgrade';\n\tproxy_set_header Host $"host";\n\tproxy_cache_bypass $"http_upgrade";\n\t}\n\tlocation ~ \.php$ {\n\tinclude snippets/fastcgi-php.conf;\n\tfastcgi_pass unix:/var/run/php/php8.0-fpm.sock;\n\t}\n\t location ~ /\.ht {\n\tdeny all;\n\t }\n}
" >>  /etc/nginx/sites-available/mysite
sudo ln -s /etc/nginx/sites-available/mysite /etc/nginx/sites-enabled/
sudo nginx -t
echo "succesfully nginx configured"
# sudo chown -R www-data:www-data /home/azureuser/phisback
echo "enter the right git url : "
read url
repo="$(echo $url | sed -r 's/.+\/([^.]+)(\.git)?/\1/')"
git clone $url
cd $repo
# sudo apt-get update
npm install
# node server.js
# sudo apt-get update
npm i -g pm2
pm2 start server.js -n api
cd 
sudo systemctl restart nginx
# pm2 stop server.js -n api