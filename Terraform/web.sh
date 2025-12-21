#!/bin/bash
apt update
apt install wget unzip apache2 -y
systemctl start apache2
systemctl enable apache2
wget "https://www.tooplate.com/zip-templates/2153_fireworks_composer.zip"
unzip -o 2153_fireworks_composer.zip
cp -r 2153_fireworks_composer/* /var/www/html/
systemctl restart apache2