#!/bin/bash

if [ $# != 1 ]; then
        echo "Script Usage: ./find_port.sh <starting search port number>"
        exit -1
fi

port=$1

while [ $port -lt 65535 ];do
        if [ ! -n "`netstat -an | grep $port`" ];then
                break
        fi

        port=`expr $port + 1`
done

echo $port
