#!/bin/bash

AMI_ID="ami-09c813fb71547fc4f"
SG_ID="sg-0235de9a0de70883b"
ZONE_ID="Z09794961ZIKJQCHWFUWN"
ZONE_NAME="devopshyn.fun"
Instances=( "mongodb" "mysql" "redis" "rabbitmq" "catalougue" "user" "cart" "shipping" "payment" "disptch" "fronted" )
for instance in ${Instances[@]}
do 
    Instance_ID=$(aws ec2 run-instances --image-id ami-09c813fb71547fc4f --instance-type t3.micro --security-group-ids sg-0235de9a0de70883b --tag-specifications 'ResourceType=instance,Tags=[{Key=Name, Value=$instance}]'  --query 'Instances[0].InstanceId' --output text)
 
    if [ $instance != "frontend" ]
    then
        IP=$(aws ec2 describe-instances --instance-ids $Instance_ID --query "Reservations[0].Instances[0].PrivateIpAddress" --output text)
    else
        IP=$(aws ec2 describe-instances --instance-ids $Instance_ID --query "Reservations[0].Instances[0].PublicIpAddress" --output text)
    fi
echo $instance IP address:$IP
done
