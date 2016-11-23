#!/bin/bash

# define item name
name={{ name }}
id={{ id }}

# check path, if not exists is exit script
if [ -d {{ tomcat_path }}/${name} ];then
   exit 1
fi

# tomcat rename
/bin/mv /tmp/{{ tomcat_version }} {{ tomcat_path }}/${name}

# get tomcat envirment(ci/release/increment)
env="$(echo $name|awk -F'-' '{print $NF}'|sed -e 's/[0-9]//g')"

# set env value
for i in $env
do
    if [ $i == ci ];then
        F=0
    elif [ $i == preview ];then
        F=40
    elif [ $i == alive ];then
        F=70
    else
        exit 1
    fi
done

# get tomcat num(1/2/3/n...)
num="$(echo $name|awk -F'-' '{print $NF}'|sed -e 's/[a-z]//g')"
http_port=$(echo 10000+100*$id+$F+5*${num}-4|bc)
shutdown_port=$(echo 10000+100*$id+$F+5*${num}-3|bc)
ajp_port=$(echo 10000+100*$id+$F+5*${num}-2|bc)
redirect_port=$(echo 10000+100*$id+$F+5*${num}-1|bc)

# modify tomcat configure port
/bin/sed -i "s/HTTP_PORT/${http_port}/g" {{ tomcat_path }}/${name}/conf/server.xml
/bin/sed -i "s/SHUTDOWN_PORT/${shutdown_port}/g" {{ tomcat_path }}/${name}/conf/server.xml 
/bin/sed -i "s/AJP_PORT/${ajp_port}/g" {{ tomcat_path }}/${name}/conf/server.xml
/bin/sed -i "s/REDIRECT_PORT/${redirect_port}/g" {{ tomcat_path }}/${name}/conf/server.xml

# modify tomcat server-id
/bin/sed -i "s/SERVER_id/${name}/g" {{ tomcat_path }}/${name}/bin/catalina.sh

# insert port info
echo "#------ $name ------#" >> {{ tomcat_path }}/tomcats_list
echo "HTTP_PORT:${http_port}" >> {{ tomcat_path }}/tomcats_list
echo "SHUTDOWN_PORT:${shutdown_port}" >> {{ tomcat_path }}/tomcats_list
echo "AJP_PORT:${ajp_port}" >> {{ tomcat_path }}/tomcats_list
echo "REDIRECT_PORT:${redirect_port}" >> {{ tomcat_path }}/tomcats_list
echo "" >> {{ tomcat_path }}/tomcats_list
