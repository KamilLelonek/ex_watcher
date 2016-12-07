#!/usr/bin/env bash

which yum
if [[ $? -eq 0 ]]
then
    sudo yum install -y inotify-tools
else
    which apt-get
    if [[ $? -eq 0 ]]
    then
        sudo apt-get install -y inotify-tools
    fi
fi
