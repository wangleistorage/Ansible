#!/bin/bash

spark_path="{{ service_path }}/{{ spark_version }}"

pid=$(ps -ef|grep -v -e x-spark -e grep|grep org.apache.spark.deploy.master.Master|awk '{print $2}')
value=$(ps -ef|grep -v -e x-spark -e grep|grep -c org.apache.spark.deploy.master.Master)


case $1 in
start)
    if [ $value -eq 0 ];then
        echo 'start spark master ...'
        cd $spark_path/bin/
        ./spark-class org.apache.spark.deploy.master.Master &
    fi
;;
stop)
     if [ ! "$pid" == "" ];then
        echo 'stop spark master ...'
        /usr/bin/kill -9 $pid
     fi
;;
restart)
    if [ ! "$pid" == "" ];then
        echo 'stop spark master ...'
        /usr/bin/kill -9 $pid
    fi
    if [ $value -eq 0 ];then
        echo 'start spark master ...'
        cd $spark_path/bin/
        ./spark-class org.apache.spark.deploy.master.Master &
    fi
;;
*)
    echo "usage: $0  (start|stop|restart)"
;;
esac
