#!/bin/bash

# Set to the location of your Hadoop installation
export HADOOP_ROOT=/N/u/scamicha/BigRed2/hadoop/default

# What filesystem to use? Choices are hdfs and lustre
# If lustre is chosen set HADOOP_LOCAL to true and make
# sure that HADOOP_DIR is accessible from all the nodes 
export HADOOP_FS=lustre

# Local directory to use for HDFS or lustre
export HADOOP_DIR=/N/dc2/scratch/scamicha/HADOOP_LUSTRE

#Globally accessible directory to copy logs to
export HADOOP_FINAL_LOG="$PBS_O_WORKDIR/$PBS_JOBID.hadoop.log"

# Is the data store node local?
# Set to true to use node local storage with HDFS or to use
# native lustre storage. For HDFS on lustre set to false and
# be sure to set HADOOP_GLOBAL
export HADOOP_LOCAL=true

# If HADOOP_LOCAL is false then this must be set to the 
# globally accessible scratch directory you want to map to
if [ ! "$HADOOP_LOCAL" = true ]; then
    export HADOOP_GLOBAL=/N/dc2/scratch/scamicha/HPCHADOOP_TEST/
fi

# Starting port to search
export HADOOP_NAMENODE_IPC_PORT=8020

# Maximum number of mappers per node
export HADOOP_MAX_MAPS=32

# Maximum number of reducers per node
export HADOOP_MAX_REDS=32


######  !!!!!!!!!! DO NOT CHANGE !!!!!!! ######
#Set data, log, and mapred directories
export HADOOP_DATA=$HADOOP_DIR/data
export HADOOP_LOG=$HADOOP_DIR/log
export HADOOP_MAPRED=$HADOOP_DIR/mapred
if [ ! "$HADOOP_LOCAL" = true ]; then
    export HADOOP_GLOBAL_DATA=$HADOOP_GLOBAL/data
    export HADOOP_GLOBAL_LOG=$HADOOP_GLOBAL/log
fi
