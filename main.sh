#!/bin/bash
# Author: Adam Bull, Rackspace UK
# Description: A script to backup to 5 Datacentres, please use config.conf to set which Datacentres you wish to backup to
# Date: 16/06/2016

# This is acting as the temporary main file until more changes are made

./generate-swiftly-configs.sh
sleep 5

./multidcbackup.sh
sleep 5

./listbackups.sh
sleep 5
