#!/bin/sh 

# Zabbix监控MySQL脚本

MYSQL_PWD="{{ zabbix_pass }}"
MYSQL_USER="{{ zabbix_user }}"
MYSQL_ADMIN="{{ mysql_path }}/bin/mysqladmin"
ARGS=1 
if [ $# -ne "$ARGS" ];then 
    echo "Please input one arguement:" 
fi 
case $1 in 
    Uptime) 
        result=`${MYSQL_ADMIN} -uzabbix -p${MYSQL_PWD} -S $MYSQL_SOCK status 2> /dev/null |cut -f2 -d":"|cut -f1 -d"T"` 
            echo $result 
            ;; 
        Com_update) 
            result=`${MYSQL_ADMIN} -uzabbix -p${MYSQL_PWD} -S $MYSQL_SOCK extended-status 2> /dev/null |grep -w "Com_update"|cut -d"|" -f3` 
            echo $result 
            ;; 
        Slow_queries) 
        result=`${MYSQL_ADMIN} -uzabbix -p${MYSQL_PWD} -S $MYSQL_SOCK status 2> /dev/null |cut -f5 -d":"|cut -f1 -d"O"` 
                echo $result 
                ;; 
    Com_select) 
        result=`${MYSQL_ADMIN} -uzabbix -p${MYSQL_PWD} -S $MYSQL_SOCK extended-status 2> /dev/null |grep -w "Com_select"|cut -d"|" -f3` 
                echo $result 
                ;; 
    Com_rollback) 
        result=`${MYSQL_ADMIN} -uzabbix -p${MYSQL_PWD} -S $MYSQL_SOCK extended-status 2> /dev/null |grep -w "Com_rollback"|cut -d"|" -f3` 
                echo $result 
                ;; 
    Questions) 
        result=`${MYSQL_ADMIN} -uzabbix -p${MYSQL_PWD} -S $MYSQL_SOCK status 2> /dev/null |cut -f4 -d":"|cut -f1 -d"S"` 
                echo $result 
                ;; 
    Com_insert) 
        result=`${MYSQL_ADMIN} -uzabbix -p${MYSQL_PWD} -S $MYSQL_SOCK extended-status 2> /dev/null |grep -w "Com_insert"|cut -d"|" -f3` 
                echo $result 
                ;; 
    Com_delete) 
        result=`${MYSQL_ADMIN} -uzabbix -p${MYSQL_PWD} -S $MYSQL_SOCK extended-status 2> /dev/null |grep -w "Com_delete"|cut -d"|" -f3` 
                echo $result 
                ;; 
    Com_commit) 
        result=`${MYSQL_ADMIN} -uzabbix -p${MYSQL_PWD} -S $MYSQL_SOCK extended-status 2> /dev/null |grep -w "Com_commit"|cut -d"|" -f3` 
                echo $result 
                ;; 
    Bytes_sent) 
        result=`${MYSQL_ADMIN} -uzabbix -p${MYSQL_PWD} -S $MYSQL_SOCK extended-status 2> /dev/null |grep -w "Bytes_sent" |cut -d"|" -f3` 
                echo $result 
                ;; 
    Bytes_received) 
        result=`${MYSQL_ADMIN} -uzabbix -p${MYSQL_PWD} -S $MYSQL_SOCK extended-status 2> /dev/null |grep -w "Bytes_received" |cut -d"|" -f3` 
                echo $result 
                ;; 
    Com_begin) 
        result=`${MYSQL_ADMIN} -uzabbix -p${MYSQL_PWD} -S $MYSQL_SOCK extended-status 2> /dev/null |grep -w "Com_begin"|cut -d"|" -f3` 
                echo $result 
                ;; 
                        
        *) 
        echo "Usage:$0(Uptime|Com_update|Slow_queries|Com_select|Com_rollback|Questions|Com_insert|Com_delete|Com_commit|Bytes_sent|Bytes_received|Com_begin)
"
        ;; 
esac 
