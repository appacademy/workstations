#!/bin/bash
# Must be run with root permissions

if [[ -z "$1" ]]; then
 SERVER_ADDR='192.168.2.195'
fi

SERVER_ADDR=$1
GET_PARTITIONS="$(dirname $0)/get-partitions.rb"

root="$($GET_PARTITIONS root)"
restore="$($GET_PARTITIONS restore)"

echo diskutil rename $restore AAStudentRestore
echo diskutil rename $root AAStudentOld

echo asr restore --source "asr://$SERVER_ADDR" \
            --target $restore --erase --noprompt \
  && echo bless --mount "$($GET_PARTITIONS $restore)" --setBoot \
  && echo 'Restore completed. Rebooting to restored partition...' \
  && echo shutdown -r now
