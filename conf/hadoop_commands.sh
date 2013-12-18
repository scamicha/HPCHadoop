#!/bin/bash

# make directory in HDFS
hadoop dfs -mkdir input
 
# copy corpus data in local fs to hdfs
hadoop dfs -copyFromLocal jane_austen_bio.txt input

# run job
hadoop jar $HADOOP_ROOT/hadoop-examples-*.jar wordcount input output

# copy result
hadoop dfs -copyToLocal output job_result
