#! /bin/bash
#prepare for installs
apt-get -f autoremove -y
apt-get update -y
apt-get upgrade -y

#install nginx
apt install nginx -y

#enable ufw
ufw allow 'Nginx HTTP'
ufw enable

#configure
chown -R $USER:$USER /var/www/html
systemctl start nginx
systemctl enable nginx
