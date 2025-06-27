#!/bin/bash

USER_ID=$(id -u)
SCRIPT_DIR=$PWD
LOG_DIR="/var/log/roboshop"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
echo $SCRIPT_NAME
LOG_FILE="$LOG_DIR/$SCRIPT_NAME.log"
mkidr -p $LOG_DIR

echo "SCRIPT START TIME IS:$(date)"

if [ $USER_ID == 0 ]
then
    echo "YOU ARE IN ROOT" | tee -a $LOG_FILE
else
    echo "ERROR:PLEASE SWITCH TO ROOT" | tee -a $LOG_FILE
    exit 1
fi

VALIDATE()
{
    if [ $1 == 0 ]
    then
        echo "$2 is SUCCESS" | tee -a $LOG_FILE
    else
        echo "$2 is FAILED" | tee -a $LOG_FILE
        exit 1
    fi
}
dnf module list nodejs &>>$LOG_FILE
VALIDATE $? "Checking if nodejs is already present"

dnf module disable nodejs -y &>>$LOG_FILE
VALIDATE $? "Disabling nodejs"

dnf module enable nodejs:20 -y &>>$LOG_FILE
VALIDATE $? "Enabling nodejs of version20"

dnf module install nodejs -y &>>$LOG_FILE
VALIDATE $? "Installing nodejs"

id roboshop
if [ $? == 0 ]
then
    echo "user roboshop is already present" | tee -a $LOG_FILE
else
    useradd --system --home /app --shell /sbin/nologin --comment "ROBOSHOP" roboshop
    VALIDATE $? "Creating roboshop system user"
fi

mkdir -p /app
VALIDATE $? "Creating app directory"

curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip 
VALIDATE $? "Copying catalogue.zip to the temp directory"

cd /app
rm -rf *
unzip /tmp/catalogue.zip &>>$LOG_FILE
VALIDATE $? "Unzipping the catalogue.zip in /app directory"

echo "Installing npm package"
npm install &>>$LOG_FILE
VALIDATE $? "Installing npm package"

echo "Copying catalogue.service file"
cp $SCRIPT_DIR/catalogue.service /etc/systemd/system/catalogue.service
VALIDATE $? "Copying catalogue.service"


systemctl daemon-reload 
systemctl enable catalogue
systemctl start catalogue


cp $SCRIPT_DIR/mongo.repo /etc/yum.repos.d/mongo.repo

echo "Installing mongodb client"
dnf install mongodb-mongosh -y &>>$LOG_FILE
VALIDATE $? "Installing mongodb client"

echo "Loading data to the db"
mongosh --host mongodb.devopshyn.fun </app/db/master-data.js &>>$LOG_FILE
VALIDATE $? "Load data into DB"