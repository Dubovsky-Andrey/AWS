#!/bin/bash

# Declare variable for Moodle version
MOODLE="MOODLE_402_STABLE"

# Step 4: Download Moodle

# Navigate to /opt directory
cd /opt

# Download the Moodle code from the git repository
git clone git://git.moodle.org/moodle.git

# Navigate into the downloaded moodle directory
cd moodle

# List all available branches
git branch -a

# Tell git which branch to track
git branch --track $MOODLE origin/$MOODLE

# Check out the specified Moodle version
git checkout $MOODLE

# Print a message
echo "Moodle version $MOODLE has been successfully downloaded and setup."

# Step 5: Copy local repository to /var/www/html/

# Copy moodle directory to /var/www/html/
cp -R /opt/moodle /var/www/html/

# Create moodledata directory
mkdir /var/moodledata

# Change ownership to www-data
chown -R www-data /var/moodledata

# Set permissions
chmod -R 777 /var/moodledata
chmod -R 0755 /var/www/html/moodle

# Print a success message
echo "Moodle has been successfully copied to /var/www/html/ and permissions have been set."

