#!/bin/bash

AMI_ID="ami-09c813fb71547fc4f"
SG_ID="sg-05238a74d61bf3665"  # replace with your SG ID
INSTANCES=("mongodb" "redis" "mysql" "rabbitmq" "catalogue" "user" "cart" "shipping" "payment" "dispatch" "frontend")
ZONE_ID="Z027214937ICR80C2B4VJ"
DOMAIN_NAME="devaraj.site"

for instance in ${INSTANCES[@]}
do
    INSTANCE_ID=$(aws ec2 run-instances --image-id ami-09c813fb71547fc4f --instance-type t2.micro --security-group-ids sg-05238a74d61bf3665 --tag-specifications "ResourceType=instance,Tags=[{Key=Name, Value=test}]" --query "Instances[0].InstanceId" --output text)
    if [ $instance != "frontend"]
    then
        IP=aws ec2 describe-instances --instance-ids $INSTANCE_ID --query "Reservations[0].Instances[0].PrivateIpAddress" --output text
    else
        IP=aws ec2 describe-instances --instance-ids $INSTANCE_ID --query "Reservations[0].Instances[0].PublicIpAddress" --output text
    fi
    echo "$instance IP address is: $IP"
done