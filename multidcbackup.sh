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
BACKUP_NAME=$(echo $BACKUP_SRC | sed 's|/||g' )
tar -cvzf "/var/backup/$BACKUP_NAME-$BACKUP_DATE-$UUID.tar.gz" "$BACKUP_SRC"


# Prepare containers

printf "\n\nCreating Container in LON for $BACKUP_DEST\n\n"
swiftly --verbose --conf swiftly-configs/swiftly-lon.conf put $BACKUP_DEST
printf "\n\nCreating Container in DFW for $BACKUP_DEST\n\n"
swiftly --verbose --conf swiftly-configs/swiftly-dfw.conf put $BACKUP_DEST
printf "\n\nCreating Container in IAD for $BACKUP_DEST\n\n"
swiftly --verbose --conf swiftly-configs/swiftly-iad.conf put $BACKUP_DEST
printf "\n\nCreating Container in ORD for $BACKUP_DEST\n\n"
swiftly --verbose --conf swiftly-configs/swiftly-ord.conf put $BACKUP_DEST
printf "\n\nCreating Contrainer in SYD for $BACKUP_DEST\n\n"
swiftly --verbose --conf swiftly-configs/swiftly-syd.conf put $BACKUP_DEST

# Perform Backups in All DC Regions (Take 5 Copies) , each copy is 3 x RAID 10
# i.e. Equivalent theoretical redundancy (3 x RAID 10) X 5

if [ "$BACKUP_TO_LON" -eq "1" ]; then
	printf "\n\n"
	printf "LONDON: Backing up ...\n"
	printf "Source: $BACKUP_SRC/ ---> Dest: cloudfiles://london/$BACKUP_DEST/$BACKUP_NAME-$BACKUP_DATE-$UUID.tar.gz\n\n"
	swiftly --verbose --conf swiftly-configs/swiftly-lon.conf --concurrency 100 put -i "/var/backup/$BACKUP_NAME-$BACKUP_DATE-$UUID.tar.gz"  "/$BACKUP_DEST/$BACKUP_NAME-$BACKUP_DATE-$UUID.tar.gz"
else 
	printf "LONDON: Not backing up ...\n\n"
fi

if [ "$BACKUP_TO_DFW" -eq "1" ]; then
	printf "\n\n"
	printf "DALLAS: Backing up ...\n"
        printf "Source: $BACKUP_SRC/ ---> Dest: cloudfiles://dallas/$BACKUP_DEST/$BACKUP_NAME-$BACKUP_DATE-$UUID.tar.gz\n\n"
	swiftly --verbose --no-snet --conf swiftly-configs/swiftly-dfw.conf --concurrency 100 put -i "/var/backup/$BACKUP_NAME-$BACKUP_DATE-$UUID.tar.gz"  "/$BACKUP_DEST/$BACKUP_NAME-$BACKUP_DATE-$UUID.tar.gz"
else
	printf "DALLAS: Not backing up ... \n\n"
fi

if [ "$BACKUP_TO_IAD" -eq "1" ]; then
	printf "\n\n"
	printf "VIRGINIA: Backing up ...\n"
        printf "Source: $BACKUP_SRC/ ---> Dest: Cloudfiles://virginia/$BACKUP_DEST/$BACKUP_NAME-$BACKUP_DATE-$UUID.tar.gz\n\n"
        swiftly --verbose --no-snet --conf swiftly-configs/swiftly-iad.conf --concurrency 100 put -i "/var/backup/$BACKUP_NAME-$BACKUP_DATE-$UUID.tar.gz"  "/$BACKUP_DEST/$BACKUP_NAME-$BACKUP_DATE-$UUID.tar.gz"
else
	printf "VIRGINIA: Not backing up ... \n\n"
fi

if [ "$BACKUP_TO_ORD" -eq "1" ]; then
	printf "\n\n"
	printf "CHICAGO: Backing up ...\n"
        printf "Source: $BACKUP_SRC/ ---> Dest: Cloudfiles://chicago/$BACKUP_DEST/$BACKUP_NAME-$BACKUP_DATE-$UUID.tar.gz\n\n"
	swiftly --verbose --no-snet --conf swiftly-configs/swiftly-ord.conf --concurrency 100 put -i "/var/backup/$BACKUP_NAME-$BACKUP_DATE-$UUID.tar.gz"  "/$BACKUP_DEST/$BACKUP_NAME-$BACKUP_DATE-$UUID.tar.gz"
else
	printf "CHICAGO: Not backing up ... \n\n"
fi

if  [ "$BACKUP_TO_SYD" -eq "1" ]; then
	printf "\n\n"
	printf "SYDNEY: Backing up ... \n\n"
        printf "Source: $BACKUP_SRC/ ---> Dest: Cloudfiles://sydney/$BACKUP_DEST/$BACKUP_NAME-$BACKUP_DATE-$UUID.tar.gz\n\n"
	swiftly --verbose --no-snet --conf swiftly-configs/swiftly-syd.conf --concurrency 100 put -i "/var/backup/$BACKUP_NAME-$BACKUP_DATE-$UUID.tar.gz"  "/$BACKUP_DEST/$BACKUP_NAME-$BACKUP_DATE-$UUID.tar.gz"
else
	printf "SYDNEY: Not backing up ...\n\n"
fi

# Validate Uploaded files match same size of zip on filesystem
# It's possible to use CRC check with zip files. Need to explore this more.

ordsize=$(swiftly --conf swiftly-configs/swiftly-ord.conf head "/$BACKUP_DEST/$BACKUP_NAME-$BACKUP_DATE-$UUID.tar.gz" | grep Content-Length | awk {'print $2'})
iadsize=$(swiftly --conf swiftly-configs/swiftly-iad.conf head "/$BACKUP_DEST/$BACKUP_NAME-$BACKUP_DATE-$UUID.tar.gz" | grep Content-Length | awk {'print $2'})
dfwsize=$(swiftly --conf swiftly-configs/swiftly-dfw.conf head "/$BACKUP_DEST/$BACKUP_NAME-$BACKUP_DATE-$UUID.tar.gz" | grep Content-Length | awk {'print $2'})
lonsize=$(swiftly --conf swiftly-configs/swiftly-lon.conf head "/$BACKUP_DEST/$BACKUP_NAME-$BACKUP_DATE-$UUID.tar.gz" | grep Content-Length | awk {'print $2'})
sydsize=$(swiftly --conf swiftly-configs/swiftly-syd.conf head "/$BACKUP_DEST/$BACKUP_NAME-$BACKUP_DATE-$UUID.tar.gz" | grep Content-Length | awk {'print $2'})

filesizeondisk=$(ls -al "/var/backup/$BACKUP_NAME-$BACKUP_DATE-$UUID.tar.gz" | awk '{print $5}')

printf "\n\n\n"
rm listbackups.txt

if [ "$lonsize" -eq "$filesizeondisk" ] 
	then
	echo "ORD: COMPLETED OK $lonsize/$filesizeondisk"
	echo "ORD: COMPLETED OK $lonsize/$filesizeondisk" >> listbackups.txt
else
	echo "ORD: NOT COMPLETED $lonsize/$filesizeondisk"
        echo "ORD: NOT COMPLETED $lonsize/$filesizeondisk" >> listbackups.txt
fi

if [ "$iadsize" -eq "$filesizeondisk" ]
	then
	echo "IAD: COMPLETED OK $iadsize/$filesizeondisk"
	echo "IAD: COMPLETED OK $iadsize/$filesizeondisk" >> listbackups.txt

else
	echo "IAD: NOT COMPLETED $iadsize/$filesizeondisk"
	echo "IAD: NOT COMPLETED $iadsize/$filesizeondisk" >> listbackups.txt
fi

if [ "$dfwsize" -eq "$filesizeondisk" ]
	then
	echo "DFW: COMPLETED OK $dfwsize/$filesizeondisk"
	echo "DFW: COMPLETED OK $dfwsize/$filesizeondisk" >> listbackups.txt
else
	echo "DFW: NOT COMPLETED $dfwsize/$filesizeondisk"
	echo "DFW: NOT COMPLETED $dfwsize/$filesizeondisk" >> listbackups.txt
fi

if [ "$ordsize" -eq "$filesizeondisk" ]
	then
	echo "ORD: COMPLETED OK $ordsize/$filesizeondisk"
	echo "ORD: COMPLETED OK $ordsize/$filesizeondisk" >> listbackups.txt
else
	echo "ORD: NOT COMPLETED $ordsize/$filesizeondisk"
	echo "ORD: NOT COMPLETED $ordsize/$filesizeondisk" >> listbackups.txt
fi

if [ "$sydsize" -eq "$filesizeondisk" ]
	then
	echo "SYD: COMPLETED OK $sydsize/$filesizeondisk"
	echo "SYD: COMPLETED OK $sydsize/$filesizeondisk" >> listbackups.txt
else
	echo "SYD: NOT COMPLETED $sydsize/$filesizeondisk"
	echo "SYD: NOT COMPLETED $sydsize/$filesizeondisk" >> listbackups.txt
fi

if [ "$EMAIL_RESULTS" != "false" ]
then
echo "not false"
./listbackups.sh >>  listbackups.txt

HOST=$(hostnamectl --static)
DATE=$(date +%Y-%M-%d)


mail -s "Obscene Backup Report: $DATE" -r "obscenebackup@$HOST" "$EMAIL_RESULTS" < listbackups.txt

else
	echo "equal false"
fi
