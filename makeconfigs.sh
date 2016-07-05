#!/bin/bash
# This file generates the swiftly configurations for the Endpoints which have been toggled for backup

# Check if the script is being run as root, if not, exit.
if [ $EUID != "0" ]; then
   echo "This script must be run as root" 1>&2
   echo
   echo
   exit 1
fi

# SET ROOT PATH & SWIFTLY CONFIG

if [ ! -d /root/automation/multi-dc-backup ]; then
    mkdir -p /root/automation/multi-dc-backup
fi

cd /root/automation/multi-dc-backup
PWD=$(pwd)

mkdir -p swiftly-configs

# LOAD CONFIGURATION FILE
source "$PWD/config.conf"

# Base Directory
BASE="swiftly-configs"


echo "[!!] Would you like to reset your configuration? Please note you will have to retype in your API key and username! [!!] options: y/n"
echo "[!!] HINT: type 'yes' if you want to try and reset your backup authentication credentials [!!]"

# Check for user input and ensure it starts with Y or N
while true; do
    read ASKRESET
    case $ASKRESET in
        [Yy]* ) echo "Deleting all swiftly configurations" && rm -rf swiftly-configs/* ; break;;
        [Nn]* ) echo "Nothing changed, exiting...";; 
        * ) echo "Please enter Y or N.";;
    esac
done

# Loop through regions and execute the same commands.
for REGION in BACKUP_TO_DFW BACKUP_TO_IAD BACKUP_TO_ORD BACKUP_TO_LON BACKUP_TO_SYD
do
    SHORT_REGION=$(echo "$REGION" | tail -c4)
    FILE="$BASE/swiftly-${SHORT_REGION,,}.conf"
    if [[ "${!REGION}" -eq 1 ]]
        then
            echo "___"
            echo "DATACENTRE: $SHORT_REGION BACKUP ON ..."
            if [ -f "$FILE" ]
                then
                    echo "DATACENTRE: $SHORT_REGION Configuration found ...\n"
                    echo "___"
                else
                    echo "DATACENTRE: $SHORT_REGION Configuration Not Found ... Creating a new one.\n"
                    echo "[swiftly]" >> $FILE
                    echo "Please type in your cloud username for accessing Cloud Files"
                    read USER
                    echo "auth_user = $USER" >> $FILE
                    echo "Please type in your cloud API key for accessing Cloud Files"
                    read KEY
                    echo "auth_key = $KEY" >> $FILE
                    echo "auth_url = https://identity.api.rackspacecloud.com/v2.0" >> "$BASE/swiftly-syd.conf"
                    echo "region = ${SHORT_REGION,,}" >> $FILE
            fi
        else
            printf "[!] No configuration file exists for $SHORT_REGION or you have disabled this backup in config.conf, to enable it set ${REGION} to 1 and re-run this script.\n"
    fi
done
