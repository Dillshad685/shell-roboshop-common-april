#!/bin/bash

USER_ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

LOGS_FOLDER="/var/log/shell-roboshop-common-april"
SCRIPT_NAME=$( echo $0 | cut -d "." -f1 )
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"
START_TIME=$(date +%s)
SCRIPT_DIR=$PWD
MONGODB_HOST=mongodb.dillshad.space
MYSQL_HOST=mysql.dillshad.space

mkdir -p $LOGS_FOLDER
echo "Script started at $(date)" | tee -a $LOG_FILE

check_root(){
    if [ $USER_ID -ne 0 ]; then
        echo -e "$Y run with super user $N"
        exit 1
    fi
}

VALIDATE(){
    if [ $1 -ne 0 ]; then
        echo -e "$R $2... error  $N" | tee -a $LOG_FILE
    else
        echo -e "$G $2... success $N" | tee -a $LOG_FILE
    fi
}

nodejs_steup(){
    dnf module disable nodejs -y &>>$LOG_FILE
    VALIDATE $? "disabling nodejs"
    dnf module enable nodejs:20 -y &>>$LOG_FILE
    VALIDATE $? "Enalbling nodejs"
    dnf install nodejs -y &>>$LOG_FILE
    VALIDATE $? "Installing nodejs"

    npm install &>>$LOG_FILE
    VALIDATE $? "Dependencies installed"

}

java_setup(){
    dnf install maven -y &>>$LOG_FILE
    VALIDATE $? "INSTALLING maven"
    mvn clean package &>>$LOG_FILE
    VALIDATE $? "packages installed"
    mv target/shipping-1.0.jar shipping.jar
    VALIDATE $? "Renaming artifact"

}

python_setup(){
    dnf install python3 gcc python3-devel -y &>>$LOG_FILE
    VALIDATE $? "installing python"
    pip3 install -r requirements.txt &>>$LOG_FILE
    VALIDATE $? "installing dependencies"
}

app_setup(){
    id roboshop
    if [ $? -ne 0 ]; then
        useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$LOG_FILE
        VALIDATE $? "User created"
    else
        echo "user already exist"
    fi
    
    mkdir -p /app
    VALIDATE $? "Creating app directory"

    curl -o /tmp/$app_name.zip https://roboshop-artifacts.s3.amazonaws.com/$app_name-v3.zip &>>$LOG_FILE
    VALIDATE $? "copied to temp path"

    cd /app
    VALIDATE $? "Changed to app directory" &>>$LOG_FILE
    rm -rf /app/*
    VALIDATE $? "removed existing code"
    unzip /tmp/$app_name.zip &>>$LOG_FILE
    VALIDATE $? "Code unzipped"
}

system_setup(){
    cp $SCRIPT_DIR/$app_name.service /etc/systemd/system/$app_name.service
    VALIDATE $? "copy systemctl setup"

    systemctl daemon-reload
    systemctl enable $app_name 
    VALIDATE $? "Enable systemctl service"
}

app_restart(){
    systemctl restart $app_name
    VALIDATE $? "$app_name restarted"
}

print_total_time(){
    END_TIME=$(date +%s)
    TOTAL_TIME=$(( $END_TIME - $START_TIME ))
    echo -e "$Y scrit executed in $TOTAL_TIME seconds $N"
}