#!/bin/bash

echo "================================="
echo "Add Repository"
echo "================================="
add-apt-repository ppa:ondrej/php -y
apt update -y

add-apt-repository ppa:ondrej/php
apt update
apt install -y php7.4 libapache2-mod-php7.4
update-alternatives --config php

a2dismod php8.1
a2enmod php7.4

echo "================================="
echo "Install additional apps"
echo "================================="
apt install -y graphviz aspell ghostscript clamav php7.4-pspell php7.4-curl php7.4-gd php7.4-intl php7.4-mysql php7.4-xml php7.4-xmlrpc php7.4-ldap php7.4-zip php7.4-soap php7.4-mbstring git