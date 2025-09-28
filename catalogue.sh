#!/bin/bash

source ./common.sh
app_name="catalogue"
check_root
app_setup
nodejs_setup
id roboshop &>> $LOG_FILE
if [ $? -ne 0 ]; then
    useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>> $LOG_FILE
    VALIDATE $? "Adding user"
else
    echo "User already exists" 
fi


cp $SCRIPT_DIR/catalogue.service /etc/systemd/system/catalogue.service
VALIDATE $? "Copying service file into systemd dir"

systemd_setup

cp $SCRIPT_DIR/mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "Copy repo file into local repos"

dnf install mongodb-mongosh -y &>> $LOG_FILE
VALIDATE $? "Installing mongodb client"

INDEX=$(mongosh mongodb.daws86s-akhil.shop --quiet --eval "db.getMongo().getDBNames().indexOf('catalogue')")
if [ $INDEX -lt 0 ]; then
    mongosh --host $MONGOHOST </app/db/master-data.js &>> $LOG_FILE
    VALIDATE $? "Connecting to mongodb and loading schema"
else
    echo "collections already exists"
fi

systemd_setup

Time
