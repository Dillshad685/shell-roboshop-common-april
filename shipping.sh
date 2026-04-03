#!/bin/bash
source ./common.sh

check_root
app_name=shipping
app_setup
java_setup
system_setup

dnf install mysql -y &>>$LOG_FILE
VALIDATE $? "mysql installed"

mysql -h $MYSQL_HOST -uroot -pRoboShop@1 -e 'use cities' &>>$LOG_FILE

if [ $? -ne 0 ]; then
    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/schema.sql &>>$LOG_FILE
    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/app-user.sql  &>>$LOG_FILE
    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/master-data.sql &>>$LOG_FILE
else
    echo "files are loaded"
fi

app_restart
print_total_time