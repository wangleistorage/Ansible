#!/bin/bash 

BKUP_DATE=`/bin/date +%Y%m%d` 
LOG="{{ zabbix_path }}/logs/nginx_status.log" 
#HOST=`/sbin/ifconfig eth0 | sed -n '/inet /{s/.*addr://;s/ .*//;p}'` 
#HOST=`/sbin/ifconfig eth0 |grep "inet addr" |awk -F[:" "] '{print $13}'` 
HOST="127.0.0.1"
PORT="80" 
 
# Functions to return nginx stats 
function active { 
    /usr/bin/curl "http://$HOST:$PORT/nginx_status" 2>/dev/null| grep 'Active' | awk '{print $NF}'       
    }     
function reading { 
    /usr/bin/curl "http://$HOST:$PORT/nginx_status" 2>/dev/null| grep 'Reading' | awk '{print $2}'       
    }     
function writing { 
    /usr/bin/curl "http://$HOST:$PORT/nginx_status" 2>/dev/null| grep 'Writing' | awk '{print $4}'       
    }     
function waiting { 
    /usr/bin/curl "http://$HOST:$PORT/nginx_status" 2>/dev/null| grep 'Waiting' | awk '{print $6}'       
    }     
function accepts { 
    /usr/bin/curl "http://$HOST:$PORT/nginx_status" 2>/dev/null| awk NR==3 | awk '{print $1}' 
    }     
function handled { 
    /usr/bin/curl "http://$HOST:$PORT/nginx_status" 2>/dev/null| awk NR==3 | awk '{print $2}' 
    }       
function requests { 
    /usr/bin/curl "http://$HOST:$PORT/nginx_status" 2>/dev/null| awk NR==3 | awk '{print $3}' 
    } 
# Run the requested function 
$1 
