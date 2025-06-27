#!/bin/bash
ID=$(id -u)
PATH=$PWD
echo $PATH

if [ $ID == 0 ]
then
    echo "You are in ROOT" 
else
    echo "ERROR:Please switch to ROOT" 
fi

VALIDATE()
{
    if [ $1 -eq 0 ]
    then
        echo "$2   SUCCESS" 
    else
        echo "$2 FAILED" 
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

sed -i 's/0.0.0.0/127.0.0.1/g' /etc/mongod.conf
VALIDATE $? "Updating IP in MONGODB conf"

systemctl restart mongod
VALIDATE $? "RESTARTING MONGODB"