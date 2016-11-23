#!/bin/bash

job_name=$(echo $1 | tr '[A-Z]' '[a-z]')

function set_tomcat_port () {

project=$(echo $job_name | awk -F"-$(echo $job_name | awk -F'-' '{print $NF}')" '{print $1}')
envirment=$(echo $job_name | awk -F'-' '{print $NF}')

case $project in
    ggl-activity)
        P=0
    ;;
    ggl-cms)
        P=1
    ;;
    ggl-common)
        P=2
    ;;
    showjoy-channel)
        P=3
    ;;
    *)
        echo "project get failed, please check input $job_name name"
        exit 1
    ;;
esac

case $envirment in
    ci)
        F=0
    ;;
    test)
        F=25
    ;;
    preview)
        F=50
    ;;
    online)
        F=75
    ;;
    *)
        echo "envirment get error, please check $job_name name"
        exit 1
    ;;
esac

http_port=$(echo 10000+100*$P+$F|bc)
shutdown_port=$(echo 10000+100*$P+$F+1|bc)
ajp_port=$(echo 10000+100*$P+$F+2|bc)
redirect_port=$(echo 10000+100*$P+$F+3|bc)

}

set_tomcat_port

cd $(dirname $0)
source push_images.sh
