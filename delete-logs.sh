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

SOURCE_DIR="/var/log/shell-practice"

if [ ! -d $SOURCE_DIR ]; then
    echo "ERROR:: source directory not available"
fi

FIND_FILES=$(find . -name "*.log" -type f -mtime +14)

while IFS=read -r line
do
    echo "Deleting lines: $line"
done