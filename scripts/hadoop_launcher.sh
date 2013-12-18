#!/bin/bash

cd $PBS_O_WORKDIR

#Configure hadoop cluster
$HPCHADOOP/scripts/configure.sh

#Run user commands
$HPCHADOOP/scripts/run.sh

#Clean up hadoop cluster
$HPCHADOOP/scripts/cleanup.sh
