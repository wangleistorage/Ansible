#!/bin/bash

function red_echo () {
#用法:  red_echo "内容"
        local what=$*
        echo -e "\e[1;31m ${what} \e[0m"
}

function if_exit () {
   if [ ! $? -eq 0 ];then
       red_echo "$1"
       exit 1
   fi
}

get_path="/root/Dockerfile/project"
jenkins_url="http://docker.wanglei.net:8080/jenkins"
check_file="/tmp/wget_check.txt"

playbook_path="/root/ansible_playbooks"

docker_user="wanglei"
docker_pass="15715746746"
docker_mail="wanglei@xkeshi.com"
docker_urls="docker.wanglei.net"

time=$(date +%Y%m%d%H%M%S)

# 1. download new package 
wget --spider $jenkins_url/job/$job_name/ws/target/jenkins.war &> $check_file
cat $check_file | grep "Remote file exists" &> /dev/null
if_exit "file not exists $jenkins_url/job/$job_name/ws/target/jenkins.war"

wget $jenkins_url/job/$job_name/ws/target/jenkins.war -O $get_path/ROOT.war &> /dev/bull
if_exit "$get_path/ROOT.war file download failed, please check ..."

# 2. login to docker.wanglei.net
docker login -u $docker_user -p $docker_pass -e $docker_mail $docker_urls
docker pull docker.wanglei.net/centos7-tomcat
if_exit "pull docker.wanglei.net/centos7-tomcat failed, please check ..."

# 3. build new images 
cd $get_path 
docker build -t $docker_urls/$job_name:$time .
docker push $docker_urls/$job_name:$time
if_exit "push $docker_urls/$job_name:$time failed, please check ..."

# 4. delete war package
rm -f $get_path/ROOT.war

# 5. execute ansible playbooks
cd $playbook_path 
ansible-playbook -i hosts playbooks/$project.yml -e "time=$time" -e "job_name=$job_name" -e "http_port=$http_port" -e "shutdown_port=$shutdown_port" -e "ajp_port=$ajp_port" -e "redirect_port=$redirect_port" 
