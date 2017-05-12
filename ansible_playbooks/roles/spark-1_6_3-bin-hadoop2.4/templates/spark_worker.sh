#!/bin/bash

spark_path="{{ service_path }}/{{ spark_version }}"
spark_master="10.29.197.45:7077"

pid=$(ps -ef|grep org.apache.spark.deploy.worker.Worker |grep -v grep|awk '{print $2}')
value=$(ps -ef|grep -v grep|grep -c org.apache.spark.deploy.worker.Worker)

case $1 in
start)
    if [ $value -eq 0 ];then
        echo 'start spark worker ...'
        cd $spark_path/bin/
        ./spark-class org.apache.spark.deploy.worker.Worker spark://$spark_master &
    fi
;;
stop)
     if [ ! "$pid" == "" ];then
        echo 'stop spark worker ...'
        /usr/bin/kill -9 $pid
     fi
;;
restart)
    if [ $value -eq 0 ];then
        echo 'start spark worker ...'
        cd $spark_path/bin/
        ./spark-class org.apache.spark.deploy.worker.Worker spark://$spark_master &
    fi
    if [ ! "$pid" == "" ];then
        echo 'stop spark worker ...'
        /usr/bin/kill -9 $pid
    fi
;;
*)
    echo "usage: $0  (start|stop|restart)"
;;
esac
