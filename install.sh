#!/bin/bash

# Create base dir
if [ ! -d /root/automation/multi-dc-backup ]; then
    mkdir -p /root/automation/multi-dc-backup/swiftly-configs
fi

# Install Packages
python -mplatform | egrep -i 'debian|ubuntu' 2>&1 > /dev/null && apt-get install python-devel python-pip -y -qq || yum install python-dev python-pip -y -q
pip install swiftly
/root/automation/multi-dc-backup
