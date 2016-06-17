#!/bin/bash
# Delete all of the managed backup containers
# SET ROOT PATH
cd /root/automation/multi-dc-backup
PWD=$(pwd)

# LOAD CONFIGURATION FILE
source "$PWD/config.conf"


swiftly --verbose --conf swiftly-configs/swiftly-syd.conf delete "$BACKUP_DEST" --recursive --until-empty
swiftly --verbose --conf swiftly-configs/swiftly-lon.conf delete "$BACKUP_DEST" --recursive --until-empty
swiftly --verbose --conf swiftly-configs/swiftly-iad.conf delete "$BACKUP_DEST" --recursive --until-empty
swiftly --verbose --conf swiftly-configs/swiftly-dfw.conf delete "$BACKUP_DEST" --recursive --until-empty
swiftly --verbose --conf swiftly-configs/swiftly-ord.conf delete "$BACKUP_DEST" --recursive --until-empty
