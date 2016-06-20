#!/bin/bash

./listbackups.sh >  listbackups.txt

HOST=$(hostnamectl --static)
DATE=$(date +%Y-%M-%d)


mail -s "Obscene Backup Report: $DATE" -r "obscenebackup@$HOST" adam.bull@rackspace.co.uk < listbackups.txt
