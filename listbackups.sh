#!/bin/sh

# This script lists the backups made so far

pwd=$(pwd)
source "$pwd/config.conf"

# LOAD CONFIGURATION FILE
source "$PWD/config.conf"


# Prepare temporary file and directory
mkdir -p tmp
touch tmp/file.txt


echo $BACKUP_TO_DFW 

if [[ "$BACKUP_TO_LON" -eq 1 && -f "swiftly-configs/swiftly-lon.conf" ]]
then
echo "London Backup Files.."
swiftly --conf swiftly-configs/swiftly-lon.conf get $BACKUP_DEST > tmp/files.txt
while read p
do
	size=`swiftly --conf swiftly-configs/swiftly-lon.conf head $BACKUP_DEST/"${p}" | grep -i content-length | awk '{print $2}'`
	size=$(echo $size | awk '{ foo = $1 / 1000 / 1000 ; print foo "MB" }')
	echo "${p} $size"
done <tmp/files.txt
size=$(swiftly --conf swiftly-configs/swiftly-lon.conf head $BACKUP_DEST | grep -i Bytes | awk '{print $2}')
size=$(echo $size | awk '{ foo = $1 / 1000 / 1000 ; print foo "MB" }')
printf "Total Container Size: $size\n\n"
fi

if [[ "$BACKUP_TO_DFW" -eq 1 && -f "swiftly-configs/swiftly-dfw.conf" ]]
then
echo "Dallas Backup Files.."
swiftly --conf swiftly-configs/swiftly-dfw.conf get $BACKUP_DEST > tmp/files.txt
while read p
do
        size=`swiftly --conf swiftly-configs/swiftly-dfw.conf head $BACKUP_DEST/"${p}" | grep -i content-length | awk '{print $2}'`
        size=$(echo $size | awk '{ foo = $1 / 1000 / 1000 ; print foo "MB" }')
        echo "${p} $size"
done <tmp/files.txt
size=$(swiftly --conf swiftly-configs/swiftly-dfw.conf head $BACKUP_DEST | grep -i Bytes | awk '{print $2}')
size=$(echo $size | awk '{ foo = $1 / 1000 / 1000 ; print foo "MB" }')
printf "Total Container Size: $size\n\n"
fi

if [[ "$BACKUP_TO_IAD" -eq 1 && -f "swiftly-configs/swiftly-iad.conf" ]]
then
echo "Virginia Backup Files.."
swiftly --conf swiftly-configs/swiftly-iad.conf get $BACKUP_DEST > tmp/files.txt
while read p
do
        size=`swiftly --conf swiftly-configs/swiftly-iad.conf head $BACKUP_DEST/"${p}" | grep -i content-length | awk '{print $2}'`
        size=$(echo $size | awk '{ foo = $1 / 1000 / 1000 ; print foo "MB" }')
        echo "${p} $size"
done <tmp/files.txt
size=$(swiftly --conf swiftly-configs/swiftly-iad.conf head $BACKUP_DEST | grep -i Bytes | awk '{print $2}')
size=$(echo $size | awk '{ foo = $1 / 1000 / 1000 ; print foo "MB" }')
printf "Total Container Size: $size\n\n"
fi


if [[ "$BACKUP_TO_ORD" -eq 1 && -f "swiftly-configs/swiftly-ord.conf" ]]
then
echo "Chicago Backup Files.."
swiftly --conf swiftly-configs/swiftly-ord.conf get $BACKUP_DEST > tmp/files.txt
while read p
do
        size=`swiftly --conf swiftly-configs/swiftly-ord.conf head $BACKUP_DEST/"${p}" | grep -i content-length | awk '{print $2}'`
        size=$(echo $size | awk '{ foo = $1 / 1000 / 1000 ; print foo "MB" }')
        echo "${p} $size"
done <tmp/files.txt
size=$(swiftly --conf swiftly-configs/swiftly-ord.conf head $BACKUP_DEST | grep -i Bytes | awk '{print $2}')
size=$(echo $size | awk '{ foo = $1 / 1000 / 1000 ; print foo "MB" }')
printf "Total Container Size: $size\n\n"
fi

if [[ "$BACKUP_TO_SYD" -eq 1 && -f "swiftly-configs/swiftly-syd.conf" ]]
then
echo "Sydney Backup Files.."
swiftly --conf swiftly-configs/swiftly-syd.conf get $BACKUP_DEST > tmp/files.txt
while read p
do
        size=`swiftly --conf swiftly-configs/swiftly-syd.conf head $BACKUP_DEST/"${p}" | grep -i content-length | awk '{print $2}'`
        size=$(echo $size | awk '{ foo = $1 / 1000 / 1000 ; print foo "MB" }')
        echo "${p} $size"
done <tmp/files.txt
size=$(swiftly --conf swiftly-configs/swiftly-syd.conf head $BACKUP_DEST | grep -i Bytes | awk '{print $2}')
size=$(echo $size | awk '{ foo = $1 / 1000 / 1000 ; print foo "MB" }')
printf "Total Container Size: $size\n\n"
fi

if [[ "$BACKUP_TO_HKG" -eq 1 && -f "swiftly-configs/swiftly-hkg.conf" ]]
then
echo "Hong Kong Backup Files.."
swiftly --conf swiftly-configs/swiftly-hkg.conf get $BACKUP_DEST > tmp/files.txt
while read p
do
        size=`swiftly --conf swiftly-configs/swiftly-hkg.conf head $BACKUP_DEST/"${p}" | grep -i content-length | awk '{print $2}'`
        size=$(echo $size | awk '{ foo = $1 / 1000 / 1000 ; print foo "MB" }')
        echo "${p} $size"
done <tmp/files.txt
size=$(swiftly --conf swiftly-configs/swiftly-hkg.conf head $BACKUP_DEST | grep -i Bytes | awk '{print $2}')
size=$(echo $size | awk '{ foo = $1 / 1000 / 1000 ; print foo "MB" }')
printf "Total Container Size: $size\n\n"
fi

