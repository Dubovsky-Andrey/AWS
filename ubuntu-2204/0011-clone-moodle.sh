#!/bin/bash

# Declare variable for Moodle version
MOODLE="MOODLE_402_STABLE"

# Step 4: Download Moodle

# Navigate to /opt directory
cd /opt

# Download the Moodle code from the git repository
sudo git clone git://git.moodle.org/moodle.git

# Navigate into the downloaded moodle directory
cd moodle

# List all available branches
sudo git branch -a

# Tell git which branch to track
sudo git branch --track $MOODLE origin/$MOODLE

# Check out the specified Moodle version
sudo git checkout $MOODLE

# Print a success message
echo "Moodle version $MOODLE has been successfully downloaded and setup."

