#!/bin/bash

# Inital script - Andre Motz
# 2013-01-26
# Tries everything to sync and to log
#
# Update 2015-01-18
#
# Update 2015-09-13
# Changing script to config-file
# Iterative instead of hardcoded links
#
# Update 2016-02-19
# finalising and adding new rsync-targets
#
# Update 2016-06-29
# adding --no-perms
# 
# Update 2016-07-23
# adding --inplace --timeout=60

source sync_config.cfg

func_backup () {
  # How many bytes might be transferred?
  WILLTRANSFERBYTES=$(rsync -an --stats $1 $2 | grep 'Total transferred file size' | awk '{print $5}'| sed 's/,//g')

  # How many files might be deleted?
  WILLDELETEFILES=$(rsync -avn --delete-after $1 $2 | grep 'deleting' | wc -l)

  # If change is more than 40GB = 40,000,000,000 bytes
  WARNINGS=""
  if [ $WILLTRANSFERBYTES -gt 400000000000 ]
    then
      WARNING="More than 40GB of changes! "
      WARNINGS="$WARNINGS $WARNING"
      # echo $WARNING
  fi

  # Ugly hack but works - If target has no '@' then it's not a rsyncd-target
  # so we can use find's numtotal of files to count
  if [[ $2 != *"@"* ]]; then
	  NUMTOTAL_OF_FILES=$(find $2 -type f | wc -l)
	  QUARTERNUMBER_OF_FILES=$(expr $NUMTOTAL_OF_FILES / 4)
	
	  if [ $WILLDELETEFILES -gt $QUARTERNUMBER_OF_FILES ]
	    then
	      WARNING="More than 25% of all files would have been deleted"
	      WARNINGS="$WARNINGS $WARNING"
	      # echo $WARNING
	  fi
  fi

  if [[ ${#WARNINGS} > 0 ]]; then
      echo "$WARNINGS - Aborting script, please start manually!"
      echo "$WARNINGS - Aborting script, please start manually!" > $3
  else
      rsync -az --no-perms --inplace --timeout=60 --size-only $1 $2 > $3 2>&1
  fi
}

# Main Loop - num of 'title' in sync_config.cfg defines num of loops
COUNTER=0
for i in "${title[@]}"
do
    let COUNTER=COUNTER+1 
done

for ((x=0; x<$COUNTER; x++))
{	
	CURRENT_TITLE=${title[$x])}
	CURRENT_SOURCE=${source[$x])}
	CURRENT_TARGET=${target[$x])}
	CURRENT_LOG=${log[$x])}
	$logger "Starte $CURRENT_TITLE"
	func_backup $CURRENT_SOURCE $CURRENT_TARGET $CURRENT_LOG
}

$logger "2_sync.sh finished"

