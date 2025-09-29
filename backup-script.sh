#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

USER=$(id -u)
SOURCE_DIR=$1
DESTINATION_DIR=$2
DAYS=${3:-14}

LOG_FOLDER="/var/log/shell-practice"
SCRIPT_NAME=$( echo $0 | cut -d "." -f1 )
LOG_FILE="$LOG_FOLDER/$SCRIPT_NAME.log"
MONGOHOST="mongodb.daws86s-akhil.shop"
SCRIPT_DIR=$PWD 
SCRIPT_TIME=$(date +%s)

mkdir -p $LOG_FOLDER

echo " Script started executing at : $(date)"\

if [ $USER -ne 0 ]; then
    echo -e "Please proceed with $R sudo permissions $N"
    exit 1
fi

if [ ! -d $SOURCE_DIR ]; then
    echo "ERROR:: Source Directory is required"
    exit 1
fi

if [ ! -d $DESTINATION_DIR_DIR ]; then
    echo "ERROR:: Destination Directory is required"
    exit 1
fi

FIND_FILES=$( find $SOURCE_DIR -name "*.log" -type f -mtime +14 )

while IFS= read -r filepath
do
    echo "Deleting the files: $filepath"

done <<< $FIND_FILES


