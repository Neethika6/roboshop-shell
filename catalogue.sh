#!/bin/bash

USER_ID=$(id -u)

if [ $USER_ID == 0 ]
then
    echo "YOU ARE IN ROOT"
else
    echo "ERROR:PLEASE SWITCH TO ROOT"
    exit 1
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
dnf module list nodejs
VALIDATE $? "Checking if nodejs is already present"

dnf module disable nodejs -y
VALIDATE $? "Disabling nodejs"

dnf module enable nodejs:20 -y
VALIDATE $? "Enabling nodejs of version20"

dnf module intall nodejs -y
VALIDATE $? "Installing nodejs"

useradd --system --home /app --shell /sbin/nologin --comment "ROBOSHOP" roboshop
VALIDATE $? "Creating roboshop system user"

mkdir -p /app
VALIDATE $? "Creating app directory"

curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip 
VALIDATE $? "Copying catalogue.zip to the temp directory"

cd /app
unzip /tmp/catalogue.zip 
VALIDATE $? "Unzipping the catalogue.zip in /app directory"

npm install
VALIDATE $? "Installing npm package"

echo "Copying catalogue.service file"
cp catalogue.service /etc/systemd/system/catalogue.service
VALIDATE $? "Copying catalogue.service"


systemctl daemon-reload
systemctl enable catalogue
systemctl start catalogue


cp mongo.repo /etc/yum.repos.d/mongo.repo

dnf install mongodb-mongosh -y
VALIDATE $? "Installing mongodb client"

mongosh --host mongodb.devopshyn.fun </app/db/master-data.js
VALIDATE $? "Load data into DB"


