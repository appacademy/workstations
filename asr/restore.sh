#!/bin/bash
# Must be run with root permissions

if [[ -n "$1" ]]; then
  SERVER_ADDR=$1
else
  SERVER_ADDR='192.168.2.195'
fi

PARTITION_INFO="$(dirname $0)/partition-info.rb"

root="$($PARTITION_INFO root)"
restore="$($PARTITION_INFO restore)"

diskutil rename $restore AAStudentRestore
diskutil rename $root AAStudentOld

asr restore --source "asr://$SERVER_ADDR" \
            --target $restore --erase --noprompt \
  && bless --mount "$($PARTITION_INFO $restore)" --setBoot \
  && echo 'Restore completed. Rebooting to restored partition...' \
  && shutdown -r now
