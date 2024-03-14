#!/bin/bash

if [ -z "$1" ] || [ $# != 1 ]
then
    echo ERROR: script started without parameters: $#
elif [[ $1 =~ ^[0-9]+$ ]]
then
    echo ERROR: script started with invalid parameter \(number: $1\)
else
    echo $1
fi
