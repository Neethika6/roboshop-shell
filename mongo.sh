#!/bin/bash

USER=$(id -u)
PATH=$PWD
echo $PATH

if [ $USER == 0 ]
then
    echo "YOU ARE ROOT USER"
else
    echo "ERROR::PLEASE SIWTCH TO ROOT"
    exit 1
fi

VALIDATE()
{
    if [ $1 == 0 ]
    then
        echo "$2..SUCCESS"
    else
        echo "$2..FAILED"
    fi
}


ls
# cp $PATH/mongo.repo /etc/yum.repos.d/mongo.repo
# VALIDATE $? "Copying mongodb repo to the repositories path"
