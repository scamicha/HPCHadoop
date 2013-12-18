#!/bin/bash

if [ $HADOOP_LOCAL ]; then
    LOCAL_TMP=$HADOOP_DATA
else
    LOCAL_TMP="/tmp/hadoop_data"
fi

#Clean out config directory
rm -rf $HPCHADOOP/etc/hadoop_config/*

#Create list of nodes given from PBS
NODEFILE="$HADOOP_ROOT/conf/nodefile"
sort -u $PBS_NODEFILE > $NODEFILE
export HADOOP_MASTER_NODE=`head -n 1 $NODEFILE`
tail +n 2 $NODEFILE > $HADOOP_ROOT/conf/slaves

#Find some ports
export HADOOP_JOBTRACKER_IPC_PORT=`expr $HADOOP_NAMENODE_IPC_PORT + 1`
HADOOP_NAMENODE_IPC_PORT=`$HPCHADOOP/scripts/find_port.sh $HADOOP_NAMENODE_IPC_PORT`
HADOOP_JOBTRACKER_IPC_PORT=`$HPCHADOOP/scripts/find_port.sh $HADOOP_JOBTRACKER_IPC_PORT`

#Copy over Hadoop files
sed -e 's|__hostname__|'$HADOOP_MASTER_NODE'|'  -e 's|__port__|'$HADOOP_NAMENODE_IPC_PORT'|' -e 's|__data__|'$LOCAL_TMP'|' $HPCHADOOP/etc/xml/core-site-template.xml  > $HADOOP_ROOT/conf/core-site.xml

sed -e 's|__hostname__|'$HADOOP_MASTER_NODE'|'  -e 's|__port__|'$HADOOP_JOBTRACKER_IPC_PORT'|' $HPCHADOOP/etc/xml/mapred-site-template.xml  > $HADOOP_ROOT/conf/mapred-site.xml

#Set log directory
sed -e 's|__log__|'$HADOOP_LOG'|' $HPCHADOOP/etc/hadoop_config/hadoop-env-template.sh > $HADOOP_ROOT/conf/hadoop-env.sh

cp $HPCHADOOP/etc/xml/hdfs-site-template.xml $HADOOP_ROOT/conf/hdfs-site.xml

#Create log and data directory
while read NODE; do
    ssh $NODE "rm -rf $HADOOP_LOG; mkdir -p $HADOOP_LOG"
    if [ $HADOOP_LOCAL ]; then
	ssh $NODE "rm -rf $HADOOP_DATA; mkdir -p $HADOOP_DATA"
    else
	mkdir -p $HADOOP_DATA/$NODE
	ssh $NODE "rm -rf /tmp/hadoop_data; ln -s $HADOOP_DATA/$NODE /tmp/hadoop_data"
    fi
done < $NODEFILE

#Format HDFS
ssh $MASTER_NODE "$HADOOP_ROOT/bin/hadoop namenode -format"

#start Hadoop cluster
ssh $MASTER_NODE "$HADOOP_ROOT/bin/start-all.sh"

#wait
sleep 120
