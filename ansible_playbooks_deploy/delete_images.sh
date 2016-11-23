#!/bin/bash

latest=$(docker images | awk '{print $2}' |grep -v latest | grep -v TAG)

for i in $latest
do
    docker rmi docker.wanglei.net/ggl-activity-ci:$i
    docker rmi docker.wanglei.net:$i
done
