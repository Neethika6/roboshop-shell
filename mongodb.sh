#!/bin/bash

ID=$(id -u)

if [ $ID == 0 ]
then
    echo "You are in ROOT"
else
    echo "ERROR:Please switch to ROOT"
    exit 1
fi

VALIDATE()
{
    if [ $1 == 0 ]
    then
        echo "$2 Installation is SUCCESS"
    else
        echo "$2 Installation FAILED"
    fi
}

dnf list installed mongodb

if [ $? == 0 ]
then
    echo "MONGODB is already installed"
else
    echo "MONGODB is not Installed.Please proceed with Installation"
    dnf install mongodb
    VALIDATE $? "MONGODB"
fi
