#This script is designed to create a CCDC website used on their ESXI server off of a fresh built CentOS 7 machine. It also adds a SSL certificate and changes the hostname

#!/bin/bash

#Defines color text
RED='\033[0;31m'
NC='\033[0m'

#Defines bold text
BOLD=$(tput bold)
NORM=$(tput sgr0)

#Installs httpd
yum install httpd -y
systemctl start httpd
systemctl enable httpd

#Moves website contents to /var/www/html directory
#MUST CHANGE "user1" to new user and "stuff1" to new directory when on new system
mv /home/user1/stuff1/index.html /var/www/html
mv /home/user1/stuff1/Colligere.jpg /var/www/html

#Create boolean to allow Colligere image to be read
setsebool -P httpd_read_user_content 1

#Create an SSL Certificate
yum install mod_ssl -y
mkdir /etc/httpd/ssl
echo ""
echo ""
echo -e "${RED}PRESS ENTER UNTIL COMMON NAME THEN ENTER${BOLD} YOUR IP${NC}${NORM}"
echo ""
echo ""
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/httpd/ssl/apache.key -out /etc/httpd/ssl/apache.crt

#Add SSL keys to files
sed -i "s/#DocumentRoot/ DocumentRoot/" /etc/httpd/conf.d/ssl.conf

#If statement asks again to enter an IP
read -p "Enter your IP again : " IP
if [[ $IP == "" ]]
then
 echo "${BOLD}ARE YOU SURE YOU DONT WANT TO ENTER AN IP${NORM}"
 echo "${BOLD}THE SCRIPT WONT WORK PROPERLY IF YOUR DO!${NORM}"
 read -p "Enter your IP : " IP
fi

#These command are desined to change contents inside the /etc/httpd/conf.d/ssl.conf file
sed -i "s/#ServerName www.example.com:443/ ServerName $IP:443/" /etc/httpd/conf.d/ssl.conf
sed -i "s{#   Server Private Key:{#   Server Private Key: /etc/httpd/ssl/apache.crt{" /etc/httpd/conf.d/ssl.conf
sed -i "s{#   Server Certificate Chain:{#   Server Certificate Chain: /etc/httpd/ssl/apache.key{" /etc/httpd/conf.d/ssl.conf

#Roll through changes
systemctl restart httpd

#Change hostname
read -p "Enter your new hostname : " hostname
hostnamectl set-hostname $hostname
hostname
