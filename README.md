# columbia
Homeserver Bash-sync script to run all sync-jobs that should be executed regularly.
It handles the complete startup, sync and shutdown-process and can be changed easily.

## Features
* Aborts sync when more than n% of files have been changed when comparing source to target
* Aborts sync when more than n-bytes have been changed when comparing source to target
* Email-reporting of sync-jobs and harddisk-smartChecks
* Centralised config-files sources, targets and 
* Uses rsync for remote-synchronisation, sendEmail to send mails from linux-machine

### sample - sync_config.cfg
``` bash
# general
logger="/usr/bin/logger -s -t ScriptSyncAll"
MAIL_RECEIVER="<yourEmail@here"
MAIL_CONTENT="mail_at_bootup.txt"
MAIL_OPTIONS="-f <serversSourceMail@here> -s <emailServer> -xu <emailUser> -xp <emailPassword>"

# sync a locally mounted source, eg a Windows-server
title[0]="Mediacenter_Photos"
source[0]="/mnt/Mediacenter_photos/"
target[0]="/media/750gb/Mediacenter_Photos/"
log[0]="/home/backupper/shellscripts/logs/rsync-mediacenter-photos.log"

# sync to my remote NAS via rsyncd
title[1]="Columbia_to_Sojus_Mediacenter_Camcorder"
source[1]="/media/1.5tb2/Mediacenter_Camcorder/"
target[1]="columbia@sojus::mediacenter-camcorder/"
log[1]="/home/backupper/shellscripts/logs/columbia_nach_sojus_mediacenter_camcorder.log"

# sync from my remote NAS via rsyncd
title[2]="Sojus_to_Columbia_macbook-andremotz"
source[2]="rsync://columbia@sojus/macbook-andremotz/"
target[2]="/media/750gb/macbook-andremotz/"
log[2]="/home/backupper/shellscripts/logs/sojus_nach_columbia_macbook-andremotz.log"
```

### sample - mail_at_bootup.txt
```
Hi Andre! Me, your Homeserver just booted up and will now start to sync all your stuff.

Cheers,
Your Homeserver
```

## Explanation
Add the following to your /etc/rc.local to start the script on each machine's startup-process:
``` bash
cd /home/backupper/shellscripts/
at now + 5 minutes -f 1_start.sh
```

Everything necessary can be defined in the sync_config.cfg:
- Email settings for mail-capabilities
- Sync source/targets are defined in arrays of the following fields: title, source, target and log. Make sure to keep a proper numbering as shown in the example
- mail_at_bootup.txt will be send to your mail to notify for the script's activity
