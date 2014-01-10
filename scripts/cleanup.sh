#!/bin/bash

$HADOOP_ROOT/bin/stop-all.sh

sleep 60

NODEFILE="$HADOOP_ROOT/conf/nodefile"

mkdir $HADOOP_GLOBAL_LOG

#Remove log and data directories
for NODE in `cat $NODEFILE`; do
    echo $NODE
    ssh $NODE "mkdir $HADOOP_GLOBAL_LOG/$NODE; cp -R $HADOOP_LOG/* $HADOOP_GLOBAL_LOG/$NODE"
    echo "done $NODE"
done

#rm -f $HADOOP_ROOT/conf/slaves $HADOOP_ROOT/conf/nodefile $HADOOP_ROOT/conf/masters
