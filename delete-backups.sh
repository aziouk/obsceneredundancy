#!/bin/bash
# Delete all of the managed backup containers
# SET ROOT PATH
cd /root/automation/multi-dc-backup
PWD=$(pwd)

# LOAD CONFIGURATION FILE
source "$PWD/config.conf"

for REGION in BACKUP_TO_DFW BACKUP_TO_IAD BACKUP_TO_ORD BACKUP_TO_LON BACKUP_TO_SYD
do
    SHORT_REGION=$(echo "$REGION" | tail -c4)
    FILE="$BASE/swiftly-${SHORT_REGION,,}.conf"
    if [[ "${!REGION}" -eq 1 ]]; then
        echo "Deleting files from ${SHORT_REGION}"
        swiftly --conf swiftly-configs/swiftly-${SHORT_REGION,,}.conf delete "$BACKUP_DEST" --recursive --until-empty
    fi
done
