#!/bin/bash
USER=$(id -u)
LOG_FOLDER="/var/log/roboshop"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
echo $SCRIPT_NAME
LOG_FILE=$LOG_FOLDER/$SCRIPT_NAME.log
echo $LOG_FILE
mkdir -p $LOG_FOLDER
echo "Script started at:$(date)" | tee -a $LOG_FILE

if [ $USER == 0 ]
then
    echo "YOU ARE IN ROOT" | tee -a $LOG_FILE
else
    echo "ERROR:PLEASE SWITCH TO ROOT" | tee -a $LOG_FILE
fi

VALIDATE()
{
    if [ $1 == 0 ]
    then
        echo "$2 is SUCCESS" | tee -a $LOG_FILE
    else
        echo "$2 is FAILED" | tee -a $LOG_FILE
    fi
}

cp mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "Copying mongodb repo to the repository directory"

dnf install mongodb-org -y &>>$LOG_FILE
VALIDATE $? "Installing mongodb"

systemctl enable mongod &>>$LOG_FILE
VALIDATE $? "Enabling mongodb"

systemctl start mongod &>>$LOG_FILE
VALIDATE $? "Starting mongodb"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
VALIDATE $? "Updating the IP of mongodb"

systemctl restart mongod &>>$LOG_FILE
VALIDATE $? "Restarting mongodb"