#!/bin/bash

$HADOOP_ROOT/bin/stop-all.sh

sleep 60

NODEFILE="$HADOOP_ROOT/conf/nodefile"

mkdir $HADOOP_FINAL_LOG

#Remove log and data directories
for NODE in `cat $NODEFILE`; do
    if [ "$HADOOP_LOCAL" = true ]; then
	ssh $NODE "mkdir $HADOOP_FINAL_LOG/$NODE; cp -R $HADOOP_LOG/* $HADOOP_FINAL_LOG/$NODE"
    else
	ssh $NODE "mkdir $HADOOP_FINAL_LOG/$NODE; cp -R $HADOOP_LOG/* $HADOOP_FINAL_LOG/$NODE"
    fi
done

if [ ! "$HADOOP_LOCAL" = true ]; then
    rm -rf $HADOOP_GLOBAL_DATA $HADOOP_GLOBAL_LOG
fi
rm -f $HADOOP_ROOT/conf/slaves $HADOOP_ROOT/conf/nodefile $HADOOP_ROOT/conf/masters
