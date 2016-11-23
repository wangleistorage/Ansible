#!/bin/sh 

mysql_sock="{{ mysql_sock }}" 
mysql_pwd="{{ mysql_pass }}"
mysql_admin="{{ mysql_path }}/bin/mysqladmin"
args=1 
if [ $# -ne "$args" ];then 
    echo "please input one arguement:" 
fi 
case $1 in 
    uptime) 
        result=`${mysql_admin} -uzabbix -p${mysql_pwd} -s $mysql_sock status 2> /dev/null|cut -f2 -d":"|cut -f1 -d"t"` 
            echo $result 
            ;; 
        com_update) 
            result=`${mysql_admin} -uzabbix -p${mysql_pwd} -s $mysql_sock extended-status 2> /dev/null |grep -w "com_update"|cut -d"|" -f3` 
            echo $result 
            ;; 
        slow_queries) 
        result=`${mysql_admin} -uzabbix -p${mysql_pwd} -s $mysql_sock status 2> /dev/null |cut -f5 -d":"|cut -f1 -d"o"` 
                echo $result 
                ;; 
    com_select) 
        result=`${mysql_admin} -uzabbix -p${mysql_pwd} -s $mysql_sock extended-status 2> /dev/null |grep -w "com_select"|cut -d"|" -f3` 
                echo $result 
                ;; 
    com_rollback) 
        result=`${mysql_admin} -uzabbix -p${mysql_pwd} -s $mysql_sock extended-status 2> /dev/null |grep -w "com_rollback"|cut -d"|" -f3` 
                echo $result 
                ;; 
    questions) 
        result=`${mysql_admin} -uzabbix -p${mysql_pwd} -s $mysql_sock status 2> /dev/null|cut -f4 -d":"|cut -f1 -d"s"` 
                echo $result 
                ;; 
    com_insert) 
        result=`${mysql_admin} -uzabbix -p${mysql_pwd} -s $mysql_sock extended-status 2> /dev/null |grep -w "com_insert"|cut -d"|" -f3` 
                echo $result 
                ;; 
    com_delete) 
        result=`${mysql_admin} -uzabbix -p${mysql_pwd} -s $mysql_sock extended-status 2> /dev/null |grep -w "com_delete"|cut -d"|" -f3` 
                echo $result 
                ;; 
    com_commit) 
        result=`${mysql_admin} -uzabbix -p${mysql_pwd} -s $mysql_sock extended-status 2> /dev/null |grep -w "com_commit"|cut -d"|" -f3` 
                echo $result 
                ;; 
    bytes_sent) 
        result=`${mysql_admin} -uzabbix -p${mysql_pwd} -s $mysql_sock extended-status 2> /dev/null |grep -w "bytes_sent" |cut -d"|" -f3` 
                echo $result 
                ;; 
    bytes_received) 
        result=`${mysql_admin} -uzabbix -p${mysql_pwd} -s $mysql_sock extended-status 2> /dev/null |grep -w "bytes_received" |cut -d"|" -f3` 
                echo $result 
                ;; 
    com_begin) 
        result=`${mysql_admin} -uzabbix -p${mysql_pwd} -s $mysql_sock extended-status 2> /dev/null |grep -w "com_begin"|cut -d"|" -f3` 
                echo $result 
                ;; 
                        
        *) 
        echo "usage:$0(uptime|com_update|slow_queries|com_select|com_rollback|questions|com_insert|com_delete|com_commit|bytes_sent|bytes_received|com_begin)
"
        ;; 
esac 
