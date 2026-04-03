#!/bin/bash

source ./common.sh
app_name=mysql
check_root

dnf install mysql-server -y &>>$LOG_FILE
VALIDATE $? "installed mysqld"
systemctl enable mysqld &>>$LOG_FILE
VALIDATE $? "ENABLED mysql"
systemctl start mysqld &>>$LOG_FILE
VALIDATE $? "started mysql"
mysql_secure_installtion --set--root-pass RoboShop@1 &>>$LOG_FILE
VALIDATE $? "mysql set root"
systemctl restart mysqld 
VALIDATE $? "restarted mysql"


