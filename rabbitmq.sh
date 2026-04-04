#!/bin/bash
source ./common.sh

app_name=rabbitmq

check_root
cp $SCRIPT_DIR/rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo &>>$LOG_FILE
VALIDATE $? "Adding RabbitMQ repo"

dnf install rabbitmq -y &>>$LOG_FILE
VALIDATE $? "installing rabbitmq"
systemctl enable rabbitmq -y &>>$LOG_FILE
VALIDATE $? "enabled rabbitmq"
systemctl start rabbitmq -y &>>$LOG_FILE
VALIDATE $? "installed rabbitmq"

rabbitmqctl add_user roboshop roboshop123 &>>$LOG_FILE
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$LOG_FILE

print_total_time
