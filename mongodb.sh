#!/bin/bash

ID=$(id -u)

if [ $ID == 0 ]
then
    echo "You are in ROOT"
else
    echo "ERROR:Please switch to ROOT"
    exit 1
fi

dnf list installed mongodb

if [ $? == 0 ]
then
    echo "MONGODB is already installed"
else
    echo "MONGODB is not Installed.Please proceed with Installation"
fi