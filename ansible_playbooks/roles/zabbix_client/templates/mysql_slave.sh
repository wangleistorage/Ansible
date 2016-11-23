#!/bin/bash

mysql_sock="{{ mysql_sock }}" 
mysql_pwd="{{ zabbix_pass }}"
mysql="{{ mysql_path }}/bin/mysql"
mysql_admin="{{ mysql_path }}/bin/mysqladmin"
mysql_user="{{ zabbix_user }}"
args=1 
if [ $# -ne "$args" ];then 
    echo "please input one arguement:" 
fi 
case $1 in 
        slave_running) 
                slave_is=($($mysql -u${mysql_user} -p${mysql_pwd} -s ${mysql_sock} -e "show slave status\g" 2> /dev/null|egrep "\bslave_.*_running\b"|awk '{print $2}'))
                if [ "${slave_is[0]}" = "yes" -a "${slave_is[1]}" = "yes" ];then
                     result="1"
                else
                     result="0"
                fi
                echo $result
        ;;
        slave_seconds)
                result=$($mysql -u${mysql_user} -p${mysql_pwd} -s ${mysql_sock} -e "show slave status\g" 2> /dev/null|egrep "\bseconds_behind_master\b"|awk '{print $2}')
                echo $result
        ;;
        *) 
                echo "usage:$0(slave_running|slave_seconds)" 
        ;; 
esac 
