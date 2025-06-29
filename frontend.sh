#!/bin/bash

USER_ID=$(id -u)
LOGS_PATH="/var/log/roboshop"
SCRIP_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE="$LOGS_PATH/$SCRIP_NAME.log"
mkdir -p $LOGS_PATH
SCRIP_PATH=$PWD

echo "Script started at:$(date)" | tee -a $LOG_FILE

if [ $USER_ID == 0 ]
then 
    echo "YOU ARE IN ROOT" | tee -a $LOG_FILE
else
    echo "ERROR:PLEASE SWITCH TO ROOT" |  tee
    exit 1
fi

VALIDATE()
{
    if [ $1 == 0 ]
    then
        echo "$2 is SUCCESS"
    else
        echo "$2 FAILED"
        exit 1
    fi
}

dnf module list nginx
VALIDATE $? "Checking if NGINX is already installed"

dnf module disable nginx -y
VALIDATE $? "Disabling already installed NGINX"

dnf module enable nginx:1.24 -y
VALIDATE $? "Enabling nginx of version 24"

dnf install nginx -y
VALIDATE $? "Installing NGINX"

systemctl enable nginx
VALIDATE $? "Enabling nginx"

systemctl start nginx
VALIDATE $? "Starting NGINX"

rm -rf /usr/share/nginx/html/*
VALIDATE $? "Removing default file in html folder"

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip
cd /usr/share/nginx/html
unzip /tmp/frontend.zip
VALIDATE $? "Unzipping files is done"

cp $SCRIP_PATH/nginx.conf /usr/share/nginx/html/nginx.conf
systemctl restart nginx
VALIDATE $? "Restarted NGINX"
