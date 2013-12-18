#!/bin/bash

#Configure hadoop cluster
$HPCHADOOP/scripts/configure.sh

#Run user commands
$HPCHADOOP/scripts/run.sh

#Clean up hadoop cluster
$HPCHADOOP/scripts/cleanup.sh
