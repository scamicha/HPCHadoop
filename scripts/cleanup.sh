#!/bin/bash

$HADOOP_ROOT/bin/stop-all.sh

sleep 60

NODEFILE="$HADOOP_ROOT/conf/nodefile"
GLOBALLOG="$PBS_O_WORKDIR/$PBS_JOBID.hadoop.log"

#Remove log and data directories
while read NODE; do
    ssh $NODE "echo 'Log from $NODE:'>> $GLOBALLOG; cat $HADOOP_LOG/* >> $GLOBALLOG; rm -rf $HADOOP_DATA $HADOOP_LOG; rm -f $HADOOP_ROOT/conf/slaves $HADOOP_ROOT/conf/nodefile"
 
