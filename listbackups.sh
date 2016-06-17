#!/bin/sh

# This script lists the backups made so far

pwd=$(pwd)
source "$pwd/config.conf"
echo "Loading London Backup Files.."
swiftly --conf swiftly-configs/swiftly-lon.conf get $BACKUP_DEST 
size=$(swiftly --conf swiftly-configs/swiftly-lon.conf head $BACKUP_DEST | grep -i Bytes | awk '{print $2}')
size=$(echo $size | awk '{ foo = $1 / 1000 / 1000 ; print foo "MB" }')
printf "Total Container Size: $size\n\n"

echo "Loading Dallas Backup Files.."
swiftly --conf swiftly-configs/swiftly-dfw.conf get $BACKUP_DEST 
size=$(swiftly --conf swiftly-configs/swiftly-dfw.conf head $BACKUP_DEST | grep -i Bytes | awk '{print $2}')
size=$(echo $size | awk '{ foo = $1 / 1000 / 1000 ; print foo "MB" }')
printf "Total Container Size: $size\n\n"


echo "Loading Virginia Backup Files.."
swiftly --conf swiftly-configs/swiftly-iad.conf get $BACKUP_DEST 
size=$(swiftly --conf swiftly-configs/swiftly-iad.conf head $BACKUP_DEST | grep -i Bytes | awk '{print $2}')
size=$(echo $size | awk '{ foo = $1 / 1000 / 1000 ; print foo "MB" }')
printf "Total Container Size: $size\n\n"

echo "Loading Chicago Backup Files.."
swiftly --conf swiftly-configs/swiftly-ord.conf get $BACKUP_DEST 
size=$(swiftly --conf swiftly-configs/swiftly-ord.conf head $BACKUP_DEST | grep -i Bytes | awk '{print $2}')
size=$(echo $size | awk '{ foo = $1 / 1000 / 1000 ; print foo "MB" }')
printf "Total Container Size: $size\n\n"

echo "Loading Sydney Backup Files.."
swiftly --conf swiftly-configs/swiftly-syd.conf get $BACKUP_DEST 
size=$(swiftly --conf swiftly-configs/swiftly-syd.conf head $BACKUP_DEST | grep -i Bytes | awk '{print $2}')
size=$(echo $size | awk '{ foo = $1 / 1000 / 1000 ; print foo "MB" }')
printf "Total Container Size: $size\n\n"

