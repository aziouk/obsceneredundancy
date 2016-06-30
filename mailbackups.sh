#!/bin/bash

# SET ROOT PATH
cd /root/automation/multi-dc-backup
PWD=$(pwd)

# LOAD CONFIGURATION FILE
source "$PWD/config.conf"

HOST=$(hostnamectl --static)
DATE=$(date +%Y-%M-%d)

if [ "$EMAIL_RESULTS" != "false" ]; then
    echo "Sending emails"
    HOST=$(hostnamectl --static)
    ./listbackups.sh | mail -s "Obscene Backup Report: $DATE" -r "obscenebackup@$HOST" "$EMAIL_RESULTS"
else
    echo "No confirmation email sent"
fi
