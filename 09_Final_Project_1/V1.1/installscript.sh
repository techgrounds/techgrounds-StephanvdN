#!/bin/bash
 sudo apt-get update
sudo apt install apache2 -y

ufw allow 'Apache'

sudo systemctl start apache2

sudo systemctl enable apache2

sudo systemctl restart apache2 

sudo systemctl status apache2