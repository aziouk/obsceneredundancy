#!/bin/bash
# Author: Adam Bull, Rackspace UK
# Date: May 17, 2016
# Revision: June 10 , 2016
# Limitations: Files are not yet CRC vallidated by gzip.
# Limitations: There is no error checking builtin to a job, so a temporary failure could cause
# 	       the backup not to compleute. You have been warned.	        

# SET ROOT PATH
cd /root/automation/multi-dc-backup
PWD=$(pwd)

# LOAD CONFIGURATION FILE
source "$PWD/config.conf"


# DO NOT CHANGE ANYTHING BELOW THIS LINE
mkdir -p /var/backup
BACKUP_DATE=$(date +%Y-%m-%d)
UUID=$(uuidgen)
BACKUP_DIR="/var/backup"
BACKUP_NAME=$(echo $BACKUP_SRC | tr -d '/' )
FILE="$(echo $BACKUP_SRC | tr -d '/')-${BACKUP_DATE}-${UUID}.tar.gz"
tar -czf "/var/backup/${BACKUP_NAME}-${BACKUP_DATE}-${UUID}.tar.gz" "$BACKUP_SRC"
BACKUP_SIZE=$(ls -al "${BACKUP_DIR}/${FILE}" | awk '{print $5}')

rm -f listbackups.txt

for REGION in BACKUP_TO_SYD BACKUP_TO_LON BACKUP_TO_ORD BACKUP_TO_IAD BACKUP_TO_DFW
    do
        SHORT_REGION=$(echo "$REGION" | tail -c4)
        if [[ ${!REGION} -eq 1 ]]; then
            # Prepare containers
            printf "\n\nCreating Container in $SHORT_REGION for $BACKUP_DEST\n\n"
            swiftly --conf swiftly-configs/swiftly-${SHORT_REGION,,}.conf put $BACKUP_DEST

            # Perform Backups in All DC Regions (Take 5 Copies) , each copy is 3 x RAID 10
            # i.e. Equivalent theoretical redundancy (3 x RAID 10) X 5
            printf "$SHORT_REGION: Backing up ...\n"
	        printf "Source: $BACKUP_SRC/ ---> Dest: cloudfiles://$SHORT_REGION/$BACKUP_DEST/$BACKUP_NAME-$BACKUP_DATE-$UUID.tar.gz\n\n"
	        swiftly --conf swiftly-configs/swiftly-${SHORT_REGION,,}.conf --concurrency 100 put -i "${BACKUP_DIR}/${FILE}" "/${BACKUP_DEST}/${FILE}"
            # Validate Uploaded files match same size of zip on filesystem
            # It's possible to use CRC check with zip files. Need to explore this more.
            cfsize=$(swiftly --conf swiftly-configs/swiftly-${SHORT_REGION,,}.conf head "${BACKUP_DEST}/${FILE}" | grep Content-Length | awk {'print $2'})
            echo "nospace${cfsize}nospace"
            echo "on disk"
            echo "nospace${BACKUP_SIZE}nospace"
            if [[ "$cfsize" -eq "$BACKUP_SIZE" ]]; then
                echo "${SHORT_REGION,,}: COMPLETED OK $cfsize/$BACKUP_SIZE" | tee listbackups.txt
            else
                echo "${SHORT_REGION,,}: NOT COMPLETED $cfsize/$BACKUP_SIZE" | tee listbackups.txt
            fi

        else 
	        printf "${SHORT_REGION}: Not backing up ...\n\n"
        fi
    done

if [ "$EMAIL_RESULTS" != "false" ]; then
    echo "Sending emails"
    HOST=$(hostnamectl --static)
    ./listbackups.sh | mail -s "Obscene Backup Report: $DATE" -r "obscenebackup@$HOST" "$EMAIL_RESULTS"
else
	echo "No confirmation email sent"
fi
