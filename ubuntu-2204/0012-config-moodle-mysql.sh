#!/bin/bash

#!/bin/bash

# Replace 'YourPasswordHere' with the password you created in step 1

MYSQL_ROOT_PASSWORD='1Moodle!'

# Replace 'passwordformoodledude' with the password of your choosing for the Moodle user
MOODLE_USER_PASSWORD='MyStr0ng!Passw0rd'

# SQL command to create a new database
CREATE_DATABASE="CREATE DATABASE moodle DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"

# SQL command to create a new user
CREATE_USER="CREATE USER 'moodledude'@'localhost' IDENTIFIED BY '$MOODLE_USER_PASSWORD';"

# SQL command to grant privileges to the new user
GRANT_PRIVILEGES="GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,CREATE TEMPORARY TABLES,DROP,INDEX,ALTER ON moodle.* TO 'moodledude'@'localhost';"

# Execute SQL commands
mysql -u root -p$MYSQL_ROOT_PASSWORD -e "$CREATE_DATABASE"
mysql -u root -p$MYSQL_ROOT_PASSWORD -e "$CREATE_USER"
mysql -u root -p$MYSQL_ROOT_PASSWORD -e "$GRANT_PRIVILEGES"

echo "Moodle database and user set up complete."


# Revert Moodle directory permissions
chmod -R 0755 /var/www/html/moodle

echo "Setup completed!"
