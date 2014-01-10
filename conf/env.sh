#!/bin/bash

# Set to the location of your Hadoop installation
export HADOOP_ROOT=/N/u/scamicha/BigRed2/hadoop/default

# Local directory to use for HDFS
export HADOOP_DATA=/tmp/hadoop/data

# Local directory to use for Hadoop logs
export HADOOP_LOG=/tmp/hadoop/log

#Globally accessible directory to copy logs to
export HADOOP_GLOBAL_LOG="$PBS_O_WORKDIR/$PBS_JOBID.hadoop.log"

# Is the data store node local?
export HADOOP_LOCAL=true

# Starting port to search
export HADOOP_NAMENODE_IPC_PORT=8020
