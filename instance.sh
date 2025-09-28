#!/bin/bash

AMI="ami-09c813fb71547fc4f"
SG="sg-0fee42dfd5533e5de"
DOMAIN="daws86s-akhil.shop"

for instance in $@
do
    INSTANCE_ID=$( aws ec2 run-instances --image-id $AMI --count 1 --instance-type t3.micro --security-group-ids $SG --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance}]" --query 'Instances[0].InstanceId' --output text )

    if [ $instance != "frontend" ]; then
        IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query "Reservations[0].Instances[0].PrivateIpAddress" --output text)
        RECORD="$instance.$DOMAIN"
    else
        IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query "Reservations[0].Instances[0].PublicIpAddress" --output text)
        RECORD="$DOMAIN"
    fi

    aws route53 change-resource-record-sets \
    --hosted-zone-id Z10111863267OBDLA0XLE \
    --change-batch '
    {
        "Comment": "Updating record set"
        ,"Changes": [{
        "Action"              : "UPSERT"
        ,"ResourceRecordSet"  : {
            "Name"              : "'$RECORD'"
            ,"Type"             : "A"
            ,"TTL"              : 1
            ,"ResourceRecords"  : [{
                "Value"         : "'$IP'"
            }]
        }
        }]
    }
    '

    echo "$instance: $IP"
done
