#!/bin/bash

AMI_ID="ami-09c813fb71547fc4f"
SG_ID="sg-0235de9a0de70883b"
ZONE_NAME="devopshyn.fun"
ZONE_ID="Z09794961ZIKJQCHWFUWN"
PACKAGES=( "mongodb" "mysql" "redis" "rabbitmq" "catalogue" "user" "cart" "shipping" "payment" "dispatch" "frontend")

for package in ${PACKAGES[@]}
do
  INSTANCE_ID=$(aws ec2 run-instances --image-id ami-09c813fb71547fc4f --instance-type t3.micro --security-group-ids sg-0235de9a0de70883b --tag-specifications "ResourceType=instance,Tags=[{Key=Name, Value=$package}]" --query 'Instances[0].InstanceId' --output text)
  if [ $package != "frontend" ]
  then
    IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query 'Reservations[*].Instances[*].PrivateIpAddress' --output text)
  else
    IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query 'Reservations[*].Instances[*].PublicIpAddress' --output text)
  fi
echo "IP address of $package is $IP"
done

