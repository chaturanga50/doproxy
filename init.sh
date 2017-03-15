#!/bin/bash

#Shell script will monitor instance and scale up and down servers in array
cp id_rsa ~/.ssh/id_rsa
chmod 600 ~/.ssh/id_rsa
eval `ssh-agent -s`
ssh-add ~/.ssh/id_rsa

STATIC_SERVER1="10.132.224.168"
STATIC_SERVER1_USER="root"
STATIC_SERVER1_CPU=$(ssh $STATIC_SERVER1_USER@$STATIC_SERVER1 'cat /tmp/CPU_LOAD')
STATIC_SERVER1_MEMORY=$(ssh $STATIC_SERVER1_USER@$STATIC_SERVER1 'cat /tmp/MEMORY_USAGE')

CPU_THRESHOLD=80.00
MEM_THRESHOLD=200

if [ "$STATIC_SERVER1_CPU" -le "$CPU_THRESHOLD" ] && [ "$STATIC_SERVER1_MEMORY" -le "$MEM_THRESHOLD" ]
    then
    