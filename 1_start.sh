#!/bin/bash

source sync_config.cfg

$logger "1_start.sh Starting SyncAllScript"
BOOTUP_MAIL_CONTENT=$(cat $MAIL_CONTENT)

sendemail -t $MAIL_RECEIVER -u "Homeserver online" $MAIL_OPTIONS -m $BOOTUP_MAIL_CONTENT

