#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

USER=$(id -u)

LOG_FOLDER="/var/log/shell-practice"
SCRIPT_NAME=$( echo $0 | cut -d "." -f1 )
LOG_FILE="$LOG_FOLDER/$SCRIPT_NAME.log"
MONGOHOST="mongodb.daws86s-akhil.shop"
SCRIPT_DIR=$PWD 
START_TIME=$(date +%s)

mkdir -p $LOG_FOLDER

echo " Script started executing at : $(date)"

check_root(){
    if [ $USER -ne 0 ]; then
        echo -e "Please proceed with $R sudo permissions $N"
        exit 1
    fi
}

VALIDATE(){
    if [ $1 -ne 0 ]; then
        echo -e "$2 $R failed $N"
        exit 1
    else
        echo -e " $2 is  $Y Successful $N" | tee -a $LOG_FILE
fi
}
nodejs_setup(){
    dnf module disable nodejs -y &>> $LOG_FILE
    VALIDATE $? "Disable default version of nodejs"

    dnf module enable nodejs:20 -y &>> $LOG_FILE
    VALIDATE $? "Enable version 20"

    dnf install nodejs -y &>> $LOG_FILE
    VALIDATE $? "Installing Nodejs"

    npm install &>> $LOG_FILE
    VALIDATE $? "Installing dependencies"
}

Time(){
    END_TIME=$(date +%s)
    TOTAL_TIME=$(($END_TIME - $START_TIME))
    echo "Total time script took: $TOTAL_TIME"
}

app_setup(){
    mkdir -p /app
    VALIDATE $? "Creating a directory"

    curl -o /tmp/$app_name.zip https://roboshop-artifacts.s3.amazonaws.com/$app_name-v3.zip &>> $LOG_FILE
    VALIDATE $? "downloading into temp directory"

    cd /app
    VALIDATE $? "cd into /app"
    rm -rf /app/*
    VALIDATE $? "Removing exisiting code"

    unzip /tmp/catalogue.zip &>> $LOG_FILE
    VALIDATE $? "Unzip into /app"
}

systemd_setup(){
    systemctl daemon-reload
    VALIDATE $? " Daemon reload"
    systemctl status enable
    VALIDATE $? " Enabling"
    systemctl start $app_name
    VALIDATE $? " start service"
}