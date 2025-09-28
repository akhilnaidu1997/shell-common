#!/bin/bash

source ./common.sh

check_root

cp mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "Adding repo"

dnf install mongodb-org -y &>> $LOG_FILE
VALIDATE $? "Installing mongodb"

systemctl enable mongod 
systemctl start mongod  &>> $LOG_FILE
VALIDATE $? "Starting mongodb"

sed -i "s/127.0.0.1/0.0.0.0/g" /etc/mongod.conf
VALIDATE $? "Giving remote access for mongodb"

systemctl restart mongod
VALIDATE $? "Restarted mongodb"

Time