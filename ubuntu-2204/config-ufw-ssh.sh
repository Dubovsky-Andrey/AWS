#!/bin/bash
echo "================================="
echo "Allow ssh"
echo "================================="
ufw allow ssh

echo "================================="
echo "Enable UFW"
echo "================================="

ufw enable