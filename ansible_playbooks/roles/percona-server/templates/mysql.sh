#!/bin/bash


my_cmd="{{ mysql_basepath }}/support-files/mysql.server"




case $1 in
start)
    $my_cmd start
;;
stop)
    $my_cmd stop
;;
restart)
    $my_cmd restart
;;
status)
    $my_cmd status
;;
*)
    echo 'Usage $0 {start|stop|restart|status}'
;;
esac
