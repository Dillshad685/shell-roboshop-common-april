#!/bin/bash

source ./common.sh
app_name=redis
check_root


dnf module disable redis -y &>>$LOG_FILE
VALIDATE $? "Disable redis"

dnf module enable redis:7 -y &>>$LOG_FILE
VALIDATE $? "enable redis"

dnf install redis -y &>>$LOG_FILE
VALIDATE $? "INSALLING REDIS"


sed -i -e 's/127.0.0.1/0.0.0.0/g' -e '/protected-mode/ c protected-mode no' /etc/redis/redis.conf
VALIDATE $? "ports are enables"

systemctl enable redis &>>$LOG_FILE
VALIDATE $? "enabled redis"
systemctl start redis &>>$LOG_FILE
VALIDATE $? "STARTED redis"

print_total_time