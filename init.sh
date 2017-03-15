#!/bin/bash

#Shell script will monitor instance and scale up and down servers in array
cp id_rsa ~/.ssh/id_rsa
chmod 600 ~/.ssh/id_rsa
eval `ssh-agent -s`
ssh-add ~/.ssh/id_rsa

CONTENT="/usr/local/doproxy"
INVENTORY="$CONTENT/inventory_output"
STATIC_SERVER1="10.132.224.168"
STATIC_SERVER1_USER="root"
STATIC_SERVER1_CPU=$(ssh $STATIC_SERVER1_USER@$STATIC_SERVER1 'cat /tmp/CPU_LOAD')
STATIC_SERVER1_MEMORY=$(ssh $STATIC_SERVER1_USER@$STATIC_SERVER1 'cat /tmp/MEMORY_USAGE')

CPU_THRESHOLD=80.00
MEM_THRESHOLD=200

if [ "$STATIC_SERVER1_CPU" -ge "$CPU_THRESHOLD" ] && [ "$STATIC_SERVER1_MEMORY" -le "$MEM_THRESHOLD" ];
    then
    cd $CONTENT; ruby doproxy.rb create
    sleep 120
fi

cd $CONTENT
ruby doproxy.rb print > $INVENTORY

if [ "$STATIC_SERVER1_CPU" -lt "$CPU_THRESHOLD" ] && [ "$STATIC_SERVER1_MEMORY" -gt "$MEM_THRESHOLD" ];
    then
    DELETE_SERVER_ID=$(tail -n1 $INVENTORY | awk '{ print $1}' | cut -d ')' -f1)
    cd $CONTENT; ruby doproxy.rb delete $DELETE_SERVER_ID
    sleep 120
fi
