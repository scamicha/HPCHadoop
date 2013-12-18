#!/bin/bash

# Set to the location of your Hadoop installation
export HADOOP_ROOT=/N/u/scamicha/BigRed2/hadoop/default

# Local directory to use for HDFS
export HADOOP_DATA=/tmp/hadoop-$USER/data

# Local directory to use for Hadoop logs
export HADOOP_LOG=/tmp/hadoop-$USER/log

# Is the data store node local?
export HADOOP_LOCAL=true

# Starting port to search
export HADOOP_NAMENODE_IPC_PORT=8020
