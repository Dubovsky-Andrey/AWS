#!/bin/bash

# Automatically set up MySQL
# WARNING: This is only for demonstration purposes and not recommended for production environments

# Update MySQL root password
sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'password1!';"

# Run mysql_secure_installation silently
sudo mysql_secure_installation <<EOF

# Enter root password1!
password

# Setup VALIDATE PASSWORD component
y

# Choose password strength level
1

# Do not change root password
n

# Remove anonymous users
y

# Allow remote root login (for demonstration purposes only, not safe for production)
n

# Remove test database
y

# Reload privilege tables
n
EOF

echo "MySQL setup completed."
