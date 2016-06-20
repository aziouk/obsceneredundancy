#!/bin/bash
# This file generates the swiftly configurations for the Endpoints which have been toggled for backup

# SET ROOT PATH & SWIFTLY CONFIG
cd /root/automation/multi-dc-backup
PWD=$(pwd)

mkdir -p swiftly-configs

# LOAD CONFIGURATION FILE
source "$PWD/config.conf"

# Base Directory
BASE="swiftly-configs"


echo "[!!] Would you like to reset your configuration? Please note you will have to retype in your API key and username! [!!] options: yes/no"
echo "[!!] HINT: type 'yes' if you want to try and reset your backup authentication credentials [!!]"

read ASKRESET
	if [ "$ASKRESET" == "yes" ]
		then
			echo "Deleting all swiftly configurations"
			rm -rf swiftly-configs/*
		else
			echo "reset was no"
	fi



FILE="$BASE/swiftly-dfw.conf"

if [ "$BACKUP_TO_DFW" -eq 1 ] ; 
then
	printf "___\n"
	echo "DATACENTRE: DFW BACKUP ON ..."
		if [ -f "$FILE" ]
			then
				printf "DATACENTRE: DFW Configuration found ...\n"
				CONFIG_DFW="1"
				printf "___\n"

			else 
				printf "DATACENTRE: Dallas Configuration Not Found ... \n" 
		fi
else
	printf "[!] No configuration file exists for DFW or you have disabled this backup in config.conf, to enable it set BACKUP_TO_SYD to 1 and re-run this script.\n"
	CONFIG_DFW=1	
fi


# Check IAD BACKUP CONFIG TOGGLED & FILE EXISTS
FILE="$BASE/swiftly-iad.conf"

if [ "$BACKUP_TO_IAD" -eq 1 ] ;
then
	printf "___\n"
	echo "DATACENTRE: VIRGINIA BACKUP ON ..."
			if [ -f "$FILE" ]
				then
					printf "DATACENTRE: Virginia Configuration Found ...\n"
					CONFIG_IAD="1"
				else
					printf "DATACENTRE: Virginia Configuration Not Found ... \n"
			fi
	else
		printf "[!] No configuration file exists for IAD or you have disabled this backup in config.conf, to enable it set BACKUP_TO_IAD to 1 and re-run this script.\n"
		CONFIG_IAD="1"
	fi


	FILE="$BASE/swiftly-ord.conf"
	if [ "$BACKUP_TO_ORD" -eq 1 ];
	then
		printf "___\n"
		echo "DATACENTRE: ORD BACKUP ON ..."
			if [ -f "$FILE" ]
				then
					printf "DATACENTRE: Chicago Configuration Found ...\n"
					CONFIG_ORD=1
					printf "___\n"
				else
					printf "DATACENTRE: Chicago Configuration Not Found ...\n"
			fi
	else
		printf "[!] No Configuration file exists for ORD or you have disabled this backup in config.conf, to enable it set BACKUP_TO_ORD to 1 and re-run this script.\n"
		CONFIG_ORD=1
	fi


	FILE="$BASE/swiftly-lon.conf"
	if [ "$BACKUP_TO_LON" -eq 1 ];
	then
		printf "___\n"
		echo "DATANCENTRE: LON BACKUP ON ..."
			if [ -f "$FILE" ]
				then
					printf "DATACENTRE: London Configuration Found ...\n"
					CONFIG_LON=1
					printf "___\n"
				else
					printf "DATACENTRE: London Configuration Not Found ...\n"
			fi
	else
		printf "[!] No Configuration file exists for LON or you have disabled this backup in config.conf, to enable it set BACKUP_TO_LON to 1 and re-run this script.\n"
		CONFIG_LON=1
	fi


	FILE="$BASE/swiftly-syd.conf"
	if [ "$BACKUP_TO_SYD" -eq 1 ];
then
	printf "___\n"
	echo "DATACENTRE: SYD BACKUP ON ..."
		if [ -f "$FILE" ]
			then
				printf "DATACENTRE: Sydney Configuration Found ...\n"
				CONFIG_SYD="1"
				printf "___\n"
			else
				printf "DATACENTRE: London Configuration Not Found ...\n"
		fi
else
	printf "[!] No Configuration file exists for SYD or you have disabled this backup in config.conf, to enable it set BACKUP_TO_SYD to 1 and re-run this script.\n"
	CONFIG_SYD=1
fi


# PROCESS AND GENERATE CONFIGS THAT ARE NOT THERE

if [ "$CONFIG_DFW" == "1" ]
	then
		echo "DFW CONFIG present, if you have any issues recheck your configuration in swiftly-configs/"
	else
		echo "DFW CONFIG NOT FOUND... autogenerating configuration"
		echo "[swiftly]" >> "$BASE/swiftly-dfw.conf"
		echo "Please type in your cloud username for accessing Cloud Files"
		read USER
		echo "auth_user = $USER" >> "$BASE/swiftly-dfw.conf"
		echo "Please type in your cloud API key for accessing Cloud Files"
		read KEY
		echo "auth_key = $KEY" >> "$BASE/swiftly-dfw.conf"
		echo "auth_url = https://identity.api.rackspacecloud.com/v2.0" >> "$BASE/swiftly-dfw.conf"
		echo "region = dfw" >> "$BASE/swiftly-dfw.conf"
fi
		
		


if [ "$CONFIG_IAD" == "1" ]
        then
                echo "IAD CONFIG present, if you have any issues recheck your configuration in swiftly-configs/"
        else
		echo $CONFIG_IAD
                echo "IAD CONFIG NOT FOUND... autogenerating configuration"
                echo "[swiftly]" >> "$BASE/swiftly-iad.conf"
                echo "Please type in your cloud username for accessing Cloud Files"
                read USER
                echo "auth_user = $USER" >> "$BASE/swiftly-iad.conf"
                echo "Please type in your cloud API key for accessing Cloud Files"
                read KEY
                echo "auth_key = $KEY" >> "$BASE/swiftly-iad.conf"
                echo "auth_url = https://identity.api.rackspacecloud.com/v2.0" >> "$BASE/swiftly-iad.conf"
                echo "region = iad" >> "$BASE/swiftly-iad.conf"
fi


if [ "$CONFIG_ORD" == "1" ]
        then
                echo "ORD CONFIG present, if you have any issues recheck your configuration in swiftly-configs/"
        else
                echo "ORD CONFIG NOT FOUND... autogenerating configuration"
                echo "[swiftly]" >> "$BASE/swiftly-ord.conf"
                echo "Please type in your cloud username for accessing Cloud Files"
                read USER
                echo "auth_user = $USER" >> "$BASE/swiftly-ord.conf"
                echo "Please type in your cloud API key for accessing Cloud Files"
                read KEY
                echo "auth_key = $KEY" >> "$BASE/swiftly-ord.conf"
                echo "auth_url = https://identity.api.rackspacecloud.com/v2.0" >> "$BASE/swiftly-ord.conf"
                echo "region = ord" >> "$BASE/swiftly-ord.conf"
fi


if [ "$CONFIG_SYD" == "1" ]
        then
                echo "SYD CONFIG present, if you have any issues recheck your configuration in swiftly-configs/"
        else
                echo "SYD CONFIG NOT FOUND... autogenerating configuration"
                echo "[swiftly]" >> "$BASE/swiftly-syd.conf"
                echo "Please type in your cloud username for accessing Cloud Files"
                read USER
                echo "auth_user = $USER" >> "$BASE/swiftly-syd.conf"
                echo "Please type in your cloud API key for accessing Cloud Files"
                read KEY
                echo "auth_key = $KEY" >> "$BASE/swiftly-syd.conf"
                echo "auth_url = https://identity.api.rackspacecloud.com/v2.0" >> "$BASE/swiftly-syd.conf"
                echo "region = syd" >> "$BASE/swiftly-syd.conf"
fi

if [ "$CONFIG_LON" == "1" ]
        then
                echo "LON CONFIG present, if you have any issues recheck your configuration in swiftly-configs/"
        else
                echo "LON CONFIG NOT FOUND... autogenerating configuration"
                echo "[swiftly]" >> "$BASE/swiftly-lon.conf"
                echo "Please type in your cloud username for accessing Cloud Files"
                read USER
                echo "auth_user = $USER" >> "$BASE/swiftly-lon.conf"
                echo "Please type in your cloud API key for accessing Cloud Files"
                read KEY
                echo "auth_key = $KEY" >> "$BASE/swiftly-lon.conf"
                echo "auth_url = https://identity.api.rackspacecloud.com/v2.0" >> "$BASE/swiftly-lon.conf"
                echo "region = lon" >> "$BASE/swiftly-lon.conf"
fi


