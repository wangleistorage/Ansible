#!/bin/bash

# 该脚本用于创建MySQL用户并授权

# 定义正确输出函数
function green_echo () {
#用法: green_echo "content"
    local what=$*
    echo -e "\e[1;32m ${what} \e[0m"
}

# 定义错误输出函数
function red_echo () {
#用法: red_echo "content"
    local what=$*
    echo -e "\e[1;31m ${what} \e[0m"
}

# MySQL修改Root密码,创建Zabbix,Backup用户,删除空密码用户
{{ mysql_cmd }}admin -uroot password '{{ mysql_pass }}'
{{ mysql_cmd }} -uroot -p'{{ mysql_pass }}' -e "grant all privileges on *.* to 'root'@'localhost' identified by '{{ mysql_pass }}';"
{{ mysql_cmd }} -uroot -p'{{ mysql_pass }}' -e "grant all privileges on *.* to 'root'@'127.0.0.1' identified by '{{ mysql_pass }}';"
{{ mysql_cmd }} -uroot -p'{{ mysql_pass }}' -e "grant replication slave on *.* to 'slave'@'%' identified by 'mysql_slave';"
{{ mysql_cmd }} -uroot -p'{{ mysql_pass }}' -e "grant usage on *.* to zabbix@'localhost' identified by 'zabbix';"
{{ mysql_cmd }} -uroot -p'{{ mysql_pass }}' -e "grant usage on *.* to zabbix@'127.0.0.1' identified by 'zabbix';"
{{ mysql_cmd }} -uroot -p'{{ mysql_pass }}' -e "delete from mysql.user where password='';"
{{ mysql_cmd }} -uroot -p'{{ mysql_pass }}' -e "flush privileges;"
if [ $? -eq 0 ];then
    green_echo "$(date "+%F %H:%M:%S") MySQL GRANT 授权成功" >> {{ mysql_log }}
else
    red_echo "$(date "+%F %H:%M:%S") MySQL GRANT 授权失败,请校验..." >> {{ mysql_log }}
    exit 1
fi

green_echo "$(date "+%F %H:%M:%S") MySQL 安装完成" >> {{ mysql_log }}

# 在脚本执行完之后自动删除
/bin/rm -f "$(dirname $0)/$(basename $0)"
