# Obscene Redundancy

![Mou icon](http://i.imgur.com/sccHXFt.jpg)

## Overview

! `WARNING Please note that this script utilizes publicnetwork interface and that bandwidth charges will apply. Ask Rackspace if you do not understand what this means to avoid increased bandwidth bills` !

Obscene redundancy is a lightweight **backup script** written in BASH which utilizes **Rackspace Cloud Files** to back up a local filesystem on a cloud server to multiple cloud files endpoints in multiple datacentres achieving much higher redundancy than is usually available within the Rackspace Cloud Files or Rackspace Cloud Backup driveclient product.

This script ** increases redundancy in an `obscene` way **. `Unless you want 6 or more copies of your data on multiple disks within multiple datacentres you might actually find Cloud files already does what you need already`. By default Cloud files keeps 3 copies of the file.

**This script significantly enhances redundancy of Rackspace Cloud files so that it approaches the capability of Amazon S3.** What Amazon calls Cross Region Redundancy. (CRR).

> cloud files is redundant, but that obscene redundancy thing is disgusting

### Goal

The goal is to _**increase redundancy**_ up to a theoretical maximum of 18 identical copies. This is what **obscene redundancy** should be. 

Each Cloud files datacentre endpoint stores 3 copies of each file. 

#### Calculating Redundancy

NUMBER_OF_DATACENTRES * 3 = TOTAL_REDUNDANT_COPIES

i.e. 3datacentres x 3 = 9 redundant copies.

## Installation & Configuration

### Cloning Repo & Pre-configuration Set-up

`mkdir -p /root/automation/multi-dc-backup`

`cd /root/automation/multi-dc-backup`

`git clone https://github.com/aziouk/obsceneredundancy`

#### Dependencies

The application only has a few dependencies which are:

python-dev/python-devel
python-pip
swiftly 

Make sure you install these using yum or apt or alternatively you can use the provideded installer.sh

`./install.sh`


### Configuration Explanation

The main configuration file is the `config.conf` file. This is used by `multidcbackup.sh`, which is the main worker that carries out the backup.

To enable a datacentre to be used as a backup endpoint, set it to 1 (true). To toggle a datecentre to disabled for backup, set it to 0 (false).

BACKUP_SRC="/var/www"

BACKUP_DEST="managed_backup"

BACKUP_TO_SYD=1

BACKUP_TO_LON=1

BACKUP_TO_ORD=0

BACKUP_TO_IAD=1

BACKUP_TO_HKG=0

BACKUP_TO_DFW=1

DAYS_RETENTION=7


**BACKUP_SRC** is the local disk location you want to backup on the server.

**BACKUP_DEST** is the cloud files container you would like to use for storing the backup.

**DAYS_RETENTION** is unused presently, however it is in the process of being implemented.

**EMAIL_RESULTS** if this is set from false to an email address it will sent you email reports to that email address every time a backup finishes.

Once you have set the endpoints you wish to use in your config.conf configuration you will want to then autogenerate the swiftly configuration. 

You will require your `mycloud primary username` (used to login to control panel) and the `API key`, being prompted to insert the credentials for each datacentre. In future revisions this will be improved so that the credential only need be typed once, and used for all US datacentres without being asked for the credentials each time for each Datacentre endpoint. 


## Generate Swiftly configuration

To generate the swiftly configuration use the makeconfigs.sh file.

`./makeconfigs.sh`

### Running Backup (make sure you configure first)

Backups can be run via multidcbackup.sh manually, OR the same file can be triggered by cron at a desired interval.

`./multidcbackup.sh `


#### SUPPORTED REGIONS


Datacentre | Name | Location
------------ | ------------- | ------------
London | LON | United Kingdom
Dallas Forth Worth | DFW  | United States
Chicago | ORD | United States
Norther Virginia | IAD | United States
Sydney | SYD | Australia
Hong Kong | HKG | Hong Kong*

'*' China's special administrative region.

#### How it works

The multidbackup script will copy files from BACKUP_SRC and tar them into a /var/backup folder. (In later versions the goal is to pipe tar directly to the API without writing to disk)


#### Links and Email

For comments and requests concerning this project please open an issue, my email is redacted to prevent spam.
