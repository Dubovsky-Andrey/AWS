#!/bin/bash
echo "================================="
echo "Show app list"
echo "================================="
ufw app list

echo "================================="
echo "Allow in "Apache"
echo "================================="
ufw allow in "Apache