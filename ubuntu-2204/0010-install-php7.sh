#!/bin/bash

echo "================================="
echo "Add Repository"
echo "================================="
add-apt-repository ppa:ondrej/php sudo apt-get update

echo "================================="
echo "Install mysql-client and php 7 "
echo "================================="
apt install -y mysql-client  php7.4 libapache2-mod-php

echo "================================="
echo "Install additional apps"
echo "================================="
apt install -y graphviz aspell ghostscript clamav php7.4-pspell php7.4-curl php7.4-gd php7.4-intl php7.4-mysql php7.4-xml php7.4-xmlrpc php7.4-ldap php7.4-zip php7.4-soap php7.4-mbstring git