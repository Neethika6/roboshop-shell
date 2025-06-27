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