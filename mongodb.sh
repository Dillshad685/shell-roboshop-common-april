#!/bin/bash
source ./common.sh

check_root

cp mongodb.repo /etc/yum.repos.d/mongo.repo &>>$LOG_FILE
VALIDATE $? "copied to repo"

dnf install mongodb-org -y &>>$LOG_FILE
VALIDATE $? "installed mongodb"

sytemctl enable mongod &>>$LOG_FILE
VALIDATE $? "ENABLED MONGO"

systemctl start mongod &>>$LOG_FILE
VALIDATE $? "start mongod"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
VALIDATE $? "opened Ips"

systemctl restart mongod &>>$LOG_FILE
VALIDATE $? "restarted mongod"

print_total_time