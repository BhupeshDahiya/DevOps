#!/bin/bash

sudo yum install wget httpd -y > /dev/null

mkdir -p /tmp/webfile

cd /tmp/webfile

# Using a prebuilt website from tooplate and coping its extracted content to httpd's hosting dir
sudo wget https://www.tooplate.com/zip-templates/2147_titan_folio.zip > /dev/null
unzip 2147_titan_folio.zip > /dev/null
sudo cp -r 2147_titan_folio/* /var/www/html

sudo systemctl start httpd
sudo systemctl enable httpd

rm -rf /tmp/webfile
