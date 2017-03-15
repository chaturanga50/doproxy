#!/bin/bash
#CPU & Memory stat collect for auto scale

CPU_LOAD=`sar -P ALL 1 2 |grep 'Average.*all' |awk -F" " '{print 100.0 -$NF}'`
echo $CPU_LOAD > /tmp/CPU_LOAD

MEMORY_USAGE=$(free -m| grep  Mem | awk '{ print $4}')
echo $MEMORY_USAGE > /tmp/MEMORY_USAGE