#!/bin/bash
# Replace with your domain and email
DOMAIN='solarspikesudio.net'
EMAIL='your_email@example.com'

# Create the web root directory
mkdir -p "/var/www/$DOMAIN"

# Change ownership to the current user
chown -R $USER:$USER "/var/www/$DOMAIN"

# Create Apache config file
tee "/etc/apache2/sites-available/$DOMAIN.conf" > /dev/null <<EOL
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
