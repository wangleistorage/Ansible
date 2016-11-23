#!/bin/bash

# 该脚本用于Cmake配置、make编译、make install 安装MySQL

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

# 初始化数据库
{{ mysql_basepath }}/scripts/mysql_install_db --basedir="{{ mysql_basepath }}" --datadir="{{ mysql_datapath }}" --user=mysql
if [ $? -eq 0 ];then
    green_echo "$(date "+%F %H:%M:%S") MySQL 初始化数据库成功" >> {{ mysql_log }}
else
    red_echo "$(date "+%F %H:%M:%S") MySQL 初始化数据库失败,请校验..." >> {{ mysql_log }}
    exit 1
fi

# 目录授权
/bin/chown -R {{ mysql_user }}.{{ mysql_group }} {{ mysql_basepath }}
/bin/chown -R {{ mysql_user }}.{{ mysql_group }} {{ mysql_datapath }}

# 启动数据库
/etc/init.d/mysqld start
if [ $? -eq 0 ];then
    green_echo "$(date "+%F %H:%M:%S") MySQL 服务启动成功" >> {{ mysql_log }}
else
    red_echo "$(date "+%F %H:%M:%S") MySQL 服务启动失败,请校验..." >> {{ mysql_log }} 
    exit 1
fi

# 在脚本执行完之后自动删除
/bin/rm -f "$(dirname $0)/$(basename $0)"
