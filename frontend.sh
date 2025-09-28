#!/bin/bash

source ./common.sh

nginx_setup

rm -rf /usr/share/nginx/html/*  &>> $LOG_FILE
VALIDATE $? " Remove the exisiting code"

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip &>> $LOG_FILE
VALIDATE $? "Downaloding to temp dir"

cd /usr/share/nginx/html 
unzip /tmp/frontend.zip &>> $LOG_FILE
VALIDATE $? "Unzipping files"

rm -rf /etc/nginx/nginx.conf

cp $SCRIPT_DIR/nginx.conf  /etc/nginx/nginx.conf
VALIDATE $? " Copy conf file"

systemd_setup