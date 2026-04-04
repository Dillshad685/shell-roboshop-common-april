#!/bin/bash

source ./common.sh
check_root

dnf module disable nginx -y &>>$LOG_FILE
VALIDATE $? "Disabled nginx"
dnf module enable nginx:1.24 -y &>>$LOG_FILE
VALIDATE $? "enable nginx"
dnf install nginx -y &>>$LOG_FILE
VALIDATE $? "INSTALLING nginx"

systemctl enable nginx
VALIDATE $? "ENABLING Nginx"

app_restart

rm -rf /usr/share/nginx/html/* &>>$LOG_FILE
VALIDATE $? "removed exisitng code"

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip &>>$LOG_FILE
VALIDATE $? "MOVED to temp path"

cd /usr/share/nginx/html/ &>>$LOG_FILE
VALIDATE $? "moved to nginx path"

unzip /tmp/frontend.zip &>>$LOG_FILE
VALIDATE $? "UNZIPPED TO main path"

app_restart

rm -rf /etc/nginx/nginx.conf &>>$LOG_FILE
VALIDATE  $? "MOVED TO conf path"

cp $SCRIPT_DIR/nginx.conf /etc/nginx/nginx.conf &>>$LOG_FILE
VALIDATE $? "conf copied"

app_restart
print_total_time


