#!/bin/bash

# Step 6: Setup MySQL Server

# Edit MySQL configuration file
sed -i '/\[mysqld\]/a default_storage_engine = innodb\ninnodb_file_per_table = 1\ninnodb_file_format = Barracuda' /etc/mysql/mysql.conf.d/mysqld.cnf

# Restart MySQL to apply changes
service mysql restart

# MySQL root password
read -sp "Enter the MySQL root password: " root_password

# Moodle database password
read -sp "Enter the Moodle user password: " moodle_password

# Create Moodle database
mysql -u root -p$root_password -e "CREATE DATABASE moodle DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"

# Create Moodle user and grant permissions
mysql -u root -p$root_password -e "CREATE USER 'moodledude'@'localhost' IDENTIFIED BY '$moodle_password';"
mysql -u root -p$root_password -e "GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,CREATE TEMPORARY TABLES,DROP,INDEX,ALTER ON moodle.* TO 'moodledude'@'localhost';"

# Step 7: Complete Setup

# Make the Moodle directory writable temporarily
chmod -R 777 /var/www/html/moodle

echo "You can now proceed with the web-based setup. Once done, press any key to continue."

# Wait for user input
read -n1 -s

# Revert Moodle directory permissions
chmod -R 0755 /var/www/html/moodle

echo "Setup completed!"
