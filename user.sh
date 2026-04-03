#!/bin/bash

source ./common.sh

app_name=user
check_root
nodejs_steup
app_setup
system_setup
app_restart
print_total_time