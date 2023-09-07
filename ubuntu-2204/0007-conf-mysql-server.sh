#!/bin/bash

# Установка MySQL, если она ещё не установлена

# Автоматический запуск mysql_secure_installation
sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '1Moodle!';"

# Ответы на вопросы mysql_secure_installation
expect_secure_mysql=$(expect -c "
set timeout 3
spawn mysql_secure_installation
expect \"Enter password for user root:\"
send \"1Moodle!\r\"
expect \"Press y|Y for Yes, any other key for No:\"
send \"y\r\"
expect \"Please enter 0 = LOW, 1 = MEDIUM and 2 = STRONG:\"
send \"1\r\"
expect \"Change the password for root ?\"
send \"n\r\"
expect \"Remove anonymous users?\"
send \"y\r\"
expect \"Disallow root login remotely?\"
send \"n\r\"
expect \"Remove test database and access to it?\"
send \"y\r\"
expect \"Reload privilege tables now?\"
send \"n\r\"
expect eof
")

# Выводить процесс выполнения скрипта
echo "$expect_secure_mysql"
