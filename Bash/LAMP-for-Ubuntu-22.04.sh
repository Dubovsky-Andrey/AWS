#!/bin/bash

# This script sets up a LAMP (Linux, Apache, MySQL, PHP) stack on Ubuntu 22.04.
# The guide for this script can be found at:
# https://www.digitalocean.com/community/tutorials/how-to-install-linux-apache-mysql-php-lamp-stack-on-ubuntu-22-04

# Update the package list
apt update -y 

# Install the Apache web server
apt install -y apache2 

# Display available UFW application profiles
ufw app list

# Allow incoming traffic for Apache in UFW (Uncomplicated Firewall)
ufw allow in "Apache"

# Check UFW status to ensure the rule is applied
ufw status

# Install MySQL server
apt install -y mysql-server

# Change authentication method for root user to 'mysql_native_password' and set the password to 'StrongPassword'
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH 'mysql_native_password' BY 'StrongPassword';"

# Secure MySQL installation
# - The first 'Y' confirms that you want to set up the VALIDATE PASSWORD plugin
# - '1' selects medium level password validation
# - 'StrongPassword' sets the password for the MySQL root user
# - The remaining 'Y's answer the subsequent security questions
echo -e "Y\n1\nStrongPassword\nStrongPassword\nY\nY\nY\nY" | mysql_secure_installation

# Check MySQL login
mysql -u root -pStrongPassword -e "SELECT user,authentication_string,plugin,host FROM mysql.user;"

# Output confirmation that MySQL setup is complete
echo "MySQL is installed and configured."

# Install PHP and related packages
apt install php libapache2-mod-php php-mysql

# Replace with your domain and email
DOMAIN='your_domain'
EMAIL='your_email@example.com'

# Create the web root directory
mkdir -p "/var/www/$DOMAIN"

# Change ownership to the current user
chown -R $USER:$USER "/var/www/$DOMAIN"

# Create Apache config file
sudo tee "/etc/apache2/sites-available/$DOMAIN.conf" > /dev/null <<EOL
<VirtualHost *:80>
    ServerName $DOMAIN
    ServerAlias www.$DOMAIN
    ServerAdmin $EMAIL
    DocumentRoot /var/www/$DOMAIN
    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOL

# Enable the site
a2ensite "$DOMAIN"

# Disable default site
a2dissite 000-default

# Modify DirectoryIndex for Apache
sed -i 's/DirectoryIndex index.html index.cgi index.pl index.php index.xhtml index.htm/DirectoryIndex index.php index.html index.cgi index.pl index.xhtml index.htm/' /etc/apache2/mods-enabled/dir.conf

# Test the configuration
apache2ctl configtest

# Reload Apache to apply changes
systemctl reload apache2

# Create an index.html file for testing
echo "<html>
  <head>
    <title>$DOMAIN website</title>
  </head>
  <body>
    <h1>Hello World!</h1>
    <p>This is the landing page of <strong>$DOMAIN</strong>.</p>
  </body>
</html>" > "/var/www/$DOMAIN/index.html"

# Create a PHP info file for testing PHP
echo '<?php
phpinfo();
?>' > "/var/www/$DOMAIN/info.php"

# Print a message indicating completion
echo "Virtual host setup complete. You can now access the site at http://$DOMAIN or http://www.$DOMAIN"

echo "You can test PHP by visiting http://$DOMAIN/info.php"

# Clean up (optional)
read -p "Would you like to remove the PHP info file for security reasons? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
  sudo rm "/var/www/$DOMAIN/info.php"
  echo "PHP info file removed."
fi

# Update the package list and upgrade all packages to their latest versions
apt update -y
apt upgrade -y 

# Add the ondrej/php repository which provides various PHP versions
add-apt-repository ppa:ondrej/php -y

# Update package list again after adding the repository
apt update -y

# Install PHP 7.4 and the associated Apache module
apt install  mysql-client php7.4 libapache2-mod-php

# Choose the default PHP version to be used by the system
update-alternatives --config php

# Disable PHP 8.1 module in Apache and enable PHP 7.4 module
a2dismod php8.1
a2enmod php7.4

# Install additional packages including Graphviz, Ghostscript, ClamAV, and various PHP extensions
apt install graphviz aspell ghostscript clamav php7.4-pspell php7.4-curl php7.4-gd php7.4-intl php7.4-mysql php7.4-xml php7.4-xmlrpc php7.4-ldap php7.4-zip php7.4-soap php7.4-mbstring git -y
service apache2 restart


# Step 4: Download Moodle
cd /opt || exit
git clone git://git.moodle.org/moodle.git
cd moodle || exit
git branch -a
git branch --track MOODLE_402_STABLE origin/MOODLE_402_STABLE
git checkout MOODLE_402_STABLE

# Step 5: Copy local repository to /var/www/html/
cp -R /opt/moodle /var/www/html/
mkdir /var/moodledata
chown -R www-data /var/moodledata
chmod -R 777 /var/moodledata
chmod -R 0755 /var/www/html/moodle

# Step 6: Setup MySQL Server
echo "[mysqld]" >> /etc/mysql/mysql.conf.d/mysqld.cnf
echo "default_storage_engine = innodb" >> /etc/mysql/mysql.conf.d/mysqld.cnf
echo "innodb_file_per_table = 1" >> /etc/mysql/mysql.conf.d/mysqld.cnf
echo "innodb_file_format = Barracuda" >> /etc/mysql/mysql.conf.d/mysqld.cnf

# Restart MySQL Server
service mysql restart

# Create Moodle Database and User
mysql -u root -p <<EOF
CREATE DATABASE moodle DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
create user 'moodledude'@'localhost' IDENTIFIED BY 'passwordformoodledude';
GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,CREATE TEMPORARY TABLES,DROP,INDEX,ALTER ON moodle.* TO 'moodledude'@'localhost';
EOF

# Step 7: Complete Setup
# Temporarily make webroot writable to create config.php via the installer
chmod -R 777 /var/www/html/moodle

echo "Please run the Moodle installer now and press [Enter] once it is done."
read -r dummy

# Revert permissions back to a more secure setting
chmod -R 0755 /var/www/html/moodle

# Signal completion
echo "Moodle setup complete."
reboot
 
