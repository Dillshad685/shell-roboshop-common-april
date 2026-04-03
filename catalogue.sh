#!/bin/bash

source ./common.sh
app_name=catalogue
check_root

nodejs_steup
app_setup
system_setup
cp $SCRIPT_DIR/mongodb.repo  /etc/yum.repos.d/mongo.repo
VALIDATE $? "installed mongorepo"
dnf module install mongodb-mongosh -y &>>$LOG_FILE
VALIDATE $? "installed mongod"

INDEX=$(mongosh mongodb.daws86s.fun --quiet --eval "db.getMongo().getDBNames().indexOf('catalogue')")
if [ $INDEX -le 0 ]; then
    mongosh --host $MONGODB_HOST </app/db/master-data.js &>>$LOG_FILE
    VALIDATE $? "Load $app_name products"
else
    echo -e "$app_name products already loaded ... $Y SKIPPING $N"
fi

app_restart

print_total_time


