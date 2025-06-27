#!/bin/bash
USER=$(id -u)
LOG_FOLDER="/var/log/roboshop"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
echo $SCRIPT_NAME
LOG_FILE=$LOG_FOLDER/$SCRIPT_NAME.log
echo $LOG_FILE
mkdir -p $LOG_FOLDER
echo "Script started at:$(date)"

if [ $USER == 0 ]
then
    echo "YOU ARE IN ROOT"
else
    echo "ERROR:PLEASE SWITCH TO ROOT"
fi

VALIDATE()
{
    if [ $1 == 0 ]
    then
        echo "$2 is SUCCESS"
    else
        echo "$2 is FAILED"
    fi
}

cp mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "Copying mongodb repo to the repository directory"

dnf install mongodb-org -y
VALIDATE $? "Installing mongodb"

systemctl enable mongod
VALIDATE $? "Enabling mongodb"

systemctl start mongod
VALIDATE $? "Starting mongodb"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
VALIDATE $? "Updating the IP of mongodb"

systemctl restart mongod
VALIDATE $? "Restarting mongodb"