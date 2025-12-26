#!/bin/bash

if [ "$SPARK_MODE" = "master" ]; then
    $SPARK_HOME/sbin/start-master.sh
else
    $SPARK_HOME/sbin/start-worker.sh spark://spark-master:7077
fi

tail -f $SPARK_HOME/logs/*