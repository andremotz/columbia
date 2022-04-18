#!/bin/bash

source sync_config.cfg

$logger "Starting 3_mailandshutdown.sh"

./maileverything.sh

$logger "sending shutdown-command +2 hours"
echo "shutdown -h 0" | at now + 2 hours
