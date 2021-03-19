#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi
if [ -z "$1" ]; then
   echo "Please define a password as first argument for the db" 1>&2
   exit 1
fi
apt update
apt upgrade
apt install zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
apt install apache2
apt install ca-certificates apt-transport-https
wget -q https://packages.sury.org/php/apt.gpg -O- | sudo apt-key add -
echo "deb https://packages.sury.org/php/ jessie main" | tee /etc/apt/sources.list.d/php.list
apt update
apt install php php7.2
apt install php7.2-cli php7.2-common php7.2-curl php7.2-gd php7.2-json php7.2-mbstring php7.2-mysql php7.2-xml php-gettext libapache2-mod-php
apt install mysql-server
mysql --user="root" --password="$1" --execute="UPDATE user SET plugin='mysql_native_password' WHERE User='root';"
mysql --user="root" --password="$1" --execute="FLUSH PRIVILEGES"
service apache2 restart
apt install phpmyadmin
service apache2 restart