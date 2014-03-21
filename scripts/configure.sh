#!/bin/bash

#Create list of nodes given from PBS
NODEFILE="$HADOOP_ROOT/conf/nodefile"
sort -u $PBS_NODEFILE > $NODEFILE
export HADOOP_MASTER_NODE=`head -n 1 $NODEFILE`
tail -n +2 $NODEFILE > $HADOOP_ROOT/conf/slaves
head -n 1 $NODEFILE > $HADOOP_ROOT/conf/masters

#Find some ports
export HADOOP_JOBTRACKER_IPC_PORT=`expr $HADOOP_NAMENODE_IPC_PORT + 1`
HADOOP_NAMENODE_IPC_PORT=`$HPCHADOOP/scripts/find_port.sh $HADOOP_NAMENODE_IPC_PORT`
HADOOP_JOBTRACKER_IPC_PORT=`$HPCHADOOP/scripts/find_port.sh $HADOOP_JOBTRACKER_IPC_PORT`

#Copy over Hadoop files
sed -e 's|__hostname__|'$HADOOP_MASTER_NODE'|'  -e 's|__port__|'$HADOOP_NAMENODE_IPC_PORT'|' -e 's|__data__|'$HADOOP_DATA'|' $HPCHADOOP/etc/xml/core-site-template.xml  > $HADOOP_ROOT/conf/core-site.xml

sed -e 's|__hostname__|'$HADOOP_MASTER_NODE'|'  -e 's|__port__|'$HADOOP_JOBTRACKER_IPC_PORT'|' -e 's|__maps__|'$HADOOP_MAX_MAPS'|' -e 's|__reds__|'$HADOOP_MAX_REDS'|' $HPCHADOOP/etc/xml/mapred-site-template.xml  > $HADOOP_ROOT/conf/mapred-site.xml

#Set log directory
sed -e 's|__log__|'$HADOOP_LOG'|' $HPCHADOOP/etc/hadoop_config/hadoop-env-template.sh > $HADOOP_ROOT/conf/hadoop-env.sh

cp $HPCHADOOP/etc/xml/hdfs-site-template.xml $HADOOP_ROOT/conf/hdfs-site.xml

#Create log and data directory
rm -rf /tmp/*

for NODE in `cat $NODEFILE`; do
    if [ "$HADOOP_LOCAL" = true ]; then
	ssh $NODE "rm -rf $HADOOP_DATA; mkdir -p $HADOOP_DATA"
	ssh $NODE "rm -rf $HADOOP_LOG; mkdir -p $HADOOP_LOG"
    else
	ssh $NODE "rm -rf $HADOOP_DATA; mkdir -p $HADOOP_GLOBAL_DATA/$NODE; mkdir -p $HADOOP_DATA; rmdir $HADOOP_DATA; ln -s $HADOOP_GLOBAL_DATA/$NODE $HADOOP_DATA"
	ssh $NODE "rm -rf $HADOOP_LOG; mkdir -p $HADOOP_GLOBAL_LOG/$NODE; mkdir -p $HADOOP_LOG; rmdir $HADOOP_LOG; ln -s $HADOOP_GLOBAL_LOG/$NODE $HADOOP_LOG"
    fi
done

#Format HDFS
ssh $HADOOP_MASTER_NODE "$HADOOP_ROOT/bin/hadoop namenode -format"

#wait
sleep 60

#start Hadoop cluster
ssh $HADOOP_MASTER_NODE "$HADOOP_ROOT/bin/start-all.sh"

#wait
sleep 120
