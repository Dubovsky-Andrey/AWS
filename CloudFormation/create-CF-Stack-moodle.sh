#!/bin/bash

# Path to the file where the variable i will be saved
COUNTER_FILE="/home/cloudshell-user/counter.txt"

# Read the value of i from the file. If the file does not exist, set i to 1
if [ -f "$COUNTER_FILE" ]; then
  i=$(<$COUNTER_FILE)
else
  i=1
fi

 aws cloudformation delete-stack --stack-name "moodle-v$i"

# Check if stack exists, if yes, wait 5 seconds and try again
while aws cloudformation describe-stacks --stack-name "moodle-v$i" &>/dev/null; do
  echo "Stack moodle-v$i already exists. Waiting 5 seconds before checking again."
  sleep 5
done

# Optional delay to ensure that the stack has been deleted
sleep 110

# Download the YAML file into /home/cloudshell-user directory and create a new CloudFormation stack
curl -o /home/cloudshell-user/ec2instance.yml https://raw.githubusercontent.com/Dubovsky-Andrey/AWS/main/YAML/ec2instance.yml
aws cloudformation create-stack --template-body file:///home/cloudshell-user/ec2instance.yml --stack-name "moodle-v$(($i + 1))"

# Increment the value of i and save it to the file
echo $(($i + 1)) > $COUNTER_FILE

