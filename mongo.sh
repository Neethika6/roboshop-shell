#!/bin/bash
USER=$(id -u)

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

ls
cp mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "Copying mongodb repo to the repository directory"

dnf install mongodb-org -y
VALIDATE $? "Installing mongodb"

systemctl enable mongodb
VALIDATE $? "Enabling mongodb"

systemctl start mongodb
VALIDATE $? "Starting mongodb"

sed -i 's/0.0.0.0/127.0.0.1/g' /etc/mongo.conf
VALIDATE "Updating the IP of mongodb"

systemctl restart mongodb
VALDIATE $? "Restarting mongodb"