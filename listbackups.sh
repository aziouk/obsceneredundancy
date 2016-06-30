#!/bin/sh

# This script lists the backups made so far
cd /root/automation/multi-dc-backup
PWD=$(pwd)

# LOAD CONFIGURATION FILE
source "$PWD/config.conf"


# Prepare temporary file and directory
mkdir -p tmp
touch tmp/file.txt

for REGION in BACKUP_TO_DFW BACKUP_TO_IAD BACKUP_TO_ORD BACKUP_TO_LON BACKUP_TO_SYD
do
    SHORT_REGION=$(echo "$REGION" | tail -c4)
    FILE="$BASE/swiftly-${SHORT_REGION,,}.conf"
    if [[ "${!REGION}" -eq 1 && -f "swiftly-configs/swiftly-${SHORT_REGION,,}.conf" ]]; then
        echo "${SHORT_REGION} Backup Files.."
            swiftly --conf swiftly-configs/swiftly-${SHORT_REGION,,}.conf get $BACKUP_DEST > tmp/files.txt
            while read p
                do
                    size=$(swiftly --conf swiftly-configs/swiftly-${SHORT_REGION,,}.conf head $BACKUP_DEST/"${p}" | grep -i content-length | awk '{print $2}')
                    size=$(echo $size | awk '{ $1 / 1000 / 1000 ; print $1 "MB" }')
                    echo "${p} $size"
                done < tmp/files.txt
        size=$(swiftly --conf swiftly-configs/swiftly-${SHORT_REGION,,}.conf head $BACKUP_DEST | grep -i Bytes | awk '{print $2}')
        size=$(echo $size | awk '{ $1 / 1000 / 1000 ; print $1 "MB" }')
        printf "Total Container Size: $size\n\n"
    fi
done
