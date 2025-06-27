#!/bin/bash

ID=$(id -u)
PATH=$PWD
echo $PATH
LOGS_FOLDER=/var/log/roboshop
SCRIPT=$(echo $0 | cut -d "." -f1)
LOG_FILE="$LOGS_FILDER/$SCRIPT.log"
mkdir -p $LOGS_FOLDER

if [ $ID == 0 ]
then
    echo "You are in ROOT" | tee -a $LOG_FILE
else
    echo "ERROR:Please switch to ROOT" | tee -a $LOG_FILE
    exit 1
fi

VALIDATE()
{
    if [ $1 == 0 ]
    then
        echo "$2   SUCCESS" | tee -a $LOG_FILE
    else
        echo "$2 FAILED" | tee 0a $LOG_FILE
    fi
}


cp $PATH/mongodb.repo /etc/yum.d.repo/mongodb.repo
VALIDATE $? "Copying mongodb repo file to repository directory"

dnf install mongodb-org -y 
VALIDATE $? "Installing MONGODB"

systemctl enable mongod 
VALIDATE $? "Enabling MONGODB"

systemctl start mongod
VALIDATE $? "Starting MONGODB"

sed -i "s/0.0.0.0/127.0.0.1/g' /etc/mongod.conf
VALIDATE $? "Updating IP in MONGODB conf"

systemctl restart mongod
VALIDATE $? "RESTARTING MONGODB"