#!/bin/bash

# Set to the location of your Hadoop installation
export HADOOP_ROOT=/N/u/scamicha/BigRed2/hadoop/default

# Local directory to use for HDFS
export HADOOP_DATA=/tmp/hadoop/data

# Local directory to use for Hadoop logs
export HADOOP_LOG=/tmp/hadoop/log

#Globally accessible directory to copy logs to
export HADOOP_FINAL_LOG="$PBS_O_WORKDIR/$PBS_JOBID.hadoop.log"

# Is the data store node local?
export HADOOP_LOCAL=false

# If HADOOP_LOCAL is false then this must be set to the 
# globally accessible scratch directory you want to map to
if [ ! "$HADOOP_LOCAL" = true ]; then
    export HADOOP_GLOBAL_DATA=/N/dc2/scratch/scamicha/HPCHADOOP_TEST/DATA
    export HADOOP_GLOBAL_LOG=/N/dc2/scratch/scamicha/HPCHADOOP_TEST/LOG
fi

# Starting port to search
export HADOOP_NAMENODE_IPC_PORT=8020

# Maximum number of mappers per node
export HADOOP_MAX_MAPS=32

# Maximum number of reducers per node
export HADOOP_MAX_REDS=32
